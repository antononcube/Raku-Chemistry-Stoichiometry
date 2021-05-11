use v6;

use Chemistry::Stoichiometry::Grammar;
use Chemistry::Stoichiometry::ResourceAccess;
use Chemistry::Stoichiometry::Actions::EquationMatrix;
use Math::Matrix;

my Chemistry::Stoichiometry::ResourceAccess $resources.instance;

class Chemistry::Stoichiometry::Actions::EquationBalance
        is Chemistry::Stoichiometry::Actions::EquationMatrix {

    method TOP($/) {
        make $/.values[0].made;
    }

    ##========================================================
    ## Equation
    ##========================================================
    method chemical-equation($/) {
        my %matrixRes = Chemistry::Stoichiometry::Actions::EquationMatrix.chemical-equation($/);

        die 'Chemical equation balancing is not implemented yet.';

        make %matrixRes;
    }

    ##========================================================
    ## Null space vectors
    ##========================================================
    method null-space(Math::Matrix $matrix) {
        my Math::Matrix $matRREF = $matrix.reduced-row-echelon-form();

        # TBD

    }
}
