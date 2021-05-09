use v6;

use Chemistry::Stoichiometry::Grammar::ChemicalElement;
use Chemistry::Stoichiometry::Grammar::ChemicalEquation;

grammar Chemistry::Stoichiometry::Grammar
        does Chemistry::Stoichiometry::Grammar::ChemicalElement
        does Chemistry::Stoichiometry::Grammar::ChemicalEquation {
    # TOP
    rule TOP { <chemical-equation> || <molecule> }
}

