use v6;

use Chemistry::Stoichiometry::Grammar;
use Chemistry::Stoichiometry::ResourceAccess;
use Math::Matrix;

my Chemistry::Stoichiometry::ResourceAccess $resources.instance;

class Chemistry::Stoichiometry::Actions::EquationMatrix {

    method TOP($/) {
        make $/.values[0].made;
    }

    ##========================================================
    ## Equation
    ##========================================================
    method chemical-equation($/) {
        my %eqs = %(LHS => $<lhs>.made, RHS => $<rhs>.made);
        my @eqElements = %eqs.values.map({ $_.values.map({ $_.keys }) }).flat.unique.sort;
        my %eqElementToIndex = @eqElements Z=> 0..@eqElements.elems;
        my @eqMats =
                do for %eqs.kv -> $side, %mix {
                    my @vecs = %mix.map({ self.make-vector($_.value, %eqElementToIndex) });
                    my Math::Matrix $mat;
                    $mat = @vecs[0] ;
                    for @vecs[1..^*] -> $v { $mat = $mat.splice-columns(-1, 0, $v) };
                    $mat
                }
        my Math::Matrix $mat = @eqMats[0].splice-columns( -1, 0, @eqMats[1] * (-1) );
        make {Equations => %eqs, Matrix => $mat, ElementToIndex => %eqElementToIndex};
    }

    method hv-sunlight($/) {
        make %();
    }

    method mixture-term($/) {
        make $/.values[0].made;
    }

    method mixture($/) {
        #my Int $k = 1;
        #my %res = do for $<mixture-term>>>.made -> %h { $k++ => %h };
        my %res = $<mixture-term> Z=> $<mixture-term>>>.made;
        make %res;
    }

    ##========================================================
    ## Molecule
    ##========================================================
    method molecule($/) {
        my %res;
        for $<sub-molecule>>>.made -> %h { %res.push( %h ) };
        make Hash(%res.pairs.map({ $_.key => $_.value.sum }));
    }

    method sub-molecule($/) {
        make $/.values[0].made;
    }

    method chemical-element($/) {
        make %( Pair.new( $/.Str, 1) );
    }

    method chemical-element-mult($/) {
        make $<chemical-element>.made.deepmap({ $_ * $<number>.made });
    }

    method group($/) {
        make $<molecule>.made;
    }

    method group-mult($/) {
        make $<group>.made.deepmap({ $_ * $<number>.made });
    }

    method number($/) {
        make $/.Str.Numeric;
    }

    ##========================================================
    ## Basis vectors
    ##========================================================
    method make-vector(%elemToCount, %elemToIndex) {
        my $res = Math::Matrix.new-zero(%elemToIndex.elems, 1);
        for %elemToCount.kv -> $elem, $count {
            $res[%elemToIndex{$elem}][0] = Rat($count);
        }
        $res
    }

    multi method make-basis-vector(Int:D $i where $i >= 0, Int:D $n where $n > 0) {
        my $res = Math::Matrix.new-zero($n, 1);
        $res[$i][0] = 1;
        $res
    }

    multi method make-basis-vector(Str:D $elem) {
        my $res = Math::Matrix.new-zero($resources.get-number-of-elements, 1);
        $res[$resources.get-atomic-number($elem)-1][0] = 1;
        $res
    }
}
