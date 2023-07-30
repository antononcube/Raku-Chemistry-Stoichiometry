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

        # Form a list of pairs and a hashmap for LHS and RHS.
        my @eqs = [LHS => $<lhs>.made, RHS => $<rhs>.made];
        my %eqs = @eqs;

        # Find all unique chemical elements in the reaction.
        my @eqElements = %eqs.values.map({ $_.values.map({ $_.keys }) }).flat.unique.sort;

        # Make an element-to-index dictionary.
        my %eqElementToIndex = @eqElements Z=> 0 .. @eqElements.elems;

        # Make a list of two matrices corresponding to LHS and RHS respectively.
        my @eqMats;
        my %compoundToIndex;

        my $k = 0;

        # Using @eqs instead of %eqs because we want LHS to be processed before RHS.
        for @eqs -> $pside {

            # Get the mixture of compounds.
            my %mix = $pside.value;

            # Sort the keys of the hashmap.
            my @pairs = %mix.pairs.sort({ $_.key });

            # Make column vectors for each compound in the reaction.
            my @vecs = @pairs.map({ self.make-vector($_.value, %eqElementToIndex) });

            # Create matrix by splicing the columns.
            my Math::Matrix $mat;
            $mat = @vecs[0];
            for @vecs[1 ..^*] -> $v { $mat = $mat.splice-columns(-1, 0, $v) };

            # Push into the result structures.
            @eqMats.push($mat);
            %compoundToIndex.push( @pairs.map({ $_.key => $k++ }) )
        }

        # Splice the LHS and RHS matrices.
        # The second matrix has to be negated since for the balance equation.
        my Math::Matrix $mat = @eqMats[0].splice-columns(-1, 0, @eqMats[1] * (-1));

        # Return a hashmap with all data structures.
        make { Equations => %eqs, Matrix => $mat, ElementToIndex => %eqElementToIndex, CompoundToIndex => %compoundToIndex };
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
    method mult-molecule($/) {
        my $m = $<number> ?? $<number>.made !! 1;
        make $<molecule>.made.map({ $_.key => $_.value * $m }).Hash;
    }

    method molecule($/) {
        my %res;
        for $<sub-molecule>>>.made -> %h { %res.push(%h) };
        make Hash(%res.pairs.map({ $_.key => $_.value.sum }));
    }

    method sub-molecule($/) {
        make $/.values[0].made;
    }

    method chemical-element($/) {
        make %( Pair.new($/.Str, 1));
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

        # Make a zero matrix with one column.
        my $res = Math::Matrix.new-zero(%elemToIndex.elems, 1);

        # Fill-in the values
        for %elemToCount.kv -> $elem, $count {
            $res[%elemToIndex{$elem}][0] = $count;
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
        $res[$resources.get-atomic-number($elem) - 1][0] = 1;
        $res
    }
}
