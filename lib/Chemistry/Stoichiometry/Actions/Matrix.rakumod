use v6;

use Chemistry::Stoichiometry::Grammar;
use Chemistry::Stoichiometry::ResourceAccess;
use Math::Matrix;

my Chemistry::Stoichiometry::ResourceAccess $resources.instance;

class Chemistry::Stoichiometry::Actions::Matrix {

    method TOP($/) {
        make $/.values[0].made;
    }

    ##========================================================
    ## Equation
    ##========================================================
    method chemical-equation($/) {
        make { LHS => $<lhs>.made, RHS => $<rhs>.made };
    }

    method hv-sunlight($/) {
        make %();
    }

    method mixture-term($/) {
        make $/.values[0].made;
    }

    method mixture($/) {
        my Int $k = 1;
        my %res = do for $<mixture-term>>>.made -> %h { $k++ => %h  };
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
    method make-basis-vector(Str:D $elem) {
        my $res = Math::Matrix.new-zero($resources.get-number-of-elements, 1);
        $res[$resources.get-atomic-number($elem)-1][0] = 1;
        $res
    }
}
