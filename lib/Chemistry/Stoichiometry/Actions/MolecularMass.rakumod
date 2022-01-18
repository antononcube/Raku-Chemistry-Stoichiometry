use Chemistry::Stoichiometry::Grammar;
use Chemistry::Stoichiometry::ResourceAccess;

class Chemistry::Stoichiometry::Actions::MolecularMass {

    method TOP($/) {
        make $/.values[0].made;
    }

    ##========================================================
    ## Equation
    ##========================================================
    method chemical-equation($/) {
        make $<lhs>.made => $<rhs>.made;
    }

    method hv-sunlight($/) {
        make 0;
    }

    method mixture-term($/) {
        make $/.values[0].made;
    }

    method mixture($/) {
        make $<mixture-term>>>.made.sum;
    }

    ##========================================================
    ## Molecule
    ##========================================================
    method molecule($/) {
        make $<sub-molecule>>>.made.sum;
    }

    method sub-molecule($/) {
        make $/.values[0].made;
    }

    method chemical-element($/) {
        make $resources.get-atomic-weight($/.Str);
    }

    method chemical-element-mult($/) {
        make $<chemical-element>.made * $<number>.made;
    }

    method group($/) {
        make $<molecule>.made;
    }

    method group-mult($/) {
        make $<group>.made * $<number>.made;
    }

    method number($/) {
        make $/.Str.Numeric;
    }

}
