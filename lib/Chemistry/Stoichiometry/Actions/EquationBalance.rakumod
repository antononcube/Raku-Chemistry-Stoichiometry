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

        my @basis = self.null-space-basis(%matrixRes<Matrix>);

        my %indexToCompound = %matrixRes<CompoundToIndex>.invert;

        # For each null-space basis vector form a balanced equation.
        my @res = do for @basis -> @b0 {

            # Rationalize the basis vector and find LCM.
            my @b = @b0.map({ $_.Rat });
            my $lcm = [lcm] @b.map({ $_.denominator});
            @b = @b.map({ $_ * $lcm });

            my Str @positive;
            my Str @negative;

            # For each element of a basis vector:
            # 1) Find to which side it belongs to
            # 2) Make the corresponding balanced term
            for 0..^@b.elems -> $i {
                if %matrixRes<Equations><LHS>{ %indexToCompound{$i} }:exists {
                    @positive.push( @b[$i].Str ~ '*' ~ %indexToCompound{$i} )
                } else {
                    @negative.push( @b[$i].Str ~ '*' ~ %indexToCompound{$i} )
                }
            }

            # Concatenate the balanced terms from both sides and
            # concatenate into a balanced equation.
            @positive.join(' + ') ~ ' -> ' ~ @negative.join(' + ')
        }

        # Return/make the array of balanced equation strings.
        make @res;
    }

    ##========================================================
    ## Null space vectors
    ##========================================================
    method null-space-basis(Math::Matrix $matrix) {

        # Find RREF.
        my Math::Matrix $matRREF = $matrix.reduced-row-echelon-form();

        # Get the number of rows and columns.
        my $nrows = $matRREF.size[0];
        my $ncols = $matRREF.size[1];

        # Make a square matrix using zero-rows.
        if $nrows < $ncols {
            $matRREF = $matRREF.splice-rows($nrows, 0, Math::Matrix.new-zero($ncols - $nrows, $ncols))
        }

        # For each diagonal element that is 0 make null-space basis vector.
        my @basis = ();
        for 0..^$matRREF.size[0] -> $i {
            my @bcol = $matRREF.column($i);
            @bcol.splice($i,1);

            my $bmax = @bcol.map({ $_.abs }).max;

            if not ($matRREF[$i][$i] eq 1 and $bmax eq 0) {
                my @b = $matRREF.column($i);
                @b.splice($i,1,[-1]);
                @b = @b.map({ -$_ });
                @basis.push(@b)
            }
        }

        @basis
    }
}
