use lib './lib';
use lib '.';
use Chemistry::Stoichiometry;
use Chemistry::Stoichiometry::Actions::MolecularMass;
use Chemistry::Stoichiometry::Actions::EquationMatrix;
use Chemistry::Stoichiometry::Actions::EquationBalance;

my $pCOMMAND = Chemistry::Stoichiometry::Grammar;

#say 'C2H5OH+O2=H2O+CO2 : ', $pCOMMAND.parse('C2H5OH+O2=H2O+CO2', actions => Chemistry::Stoichiometry::Actions::EquationMatrix).made;
#say 'C2H5OH+O2=H2O+CO2 : ', $pCOMMAND.parse('C2H5OH+O2=H2O+CO2', actions => Chemistry::Stoichiometry::Actions::EquationBalance).made;
#say 'H+O=H2O : ', $pCOMMAND.parse('H+O=H2O', actions => Chemistry::Stoichiometry::Actions::EquationBalance).made;
#say 'K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO : ', $pCOMMAND.parse('K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO', actions => Chemistry::Stoichiometry::Actions::EquationBalance).made;

#say balance-chemical-equation( 'C2H5OH+O2=H2O+CO2' );

#say balance-chemical-equation( 'K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO' );


#say $pCOMMAND.parse('C2H5OH');
#say 'C2H5OH : ', $pCOMMAND.parse('C2H5OH', actions => Chemistry::Stoichiometry::Actions::MolecularMass).made;
#say 'K4Fe(CN)6 : ', $pCOMMAND.parse('K4Fe(CN)6', actions => Chemistry::Stoichiometry::Actions::MolecularMass).made;
#say 'C2H5OH + (O2)3 == (H2O)3 + (CO2)2 : ', $pCOMMAND.parse('C2H5OH + (O2)3 == (H2O)3 + (CO2)2', actions => Chemistry::Stoichiometry::Actions::MolecularMass).made;

#say $pCOMMAND.parse('C2H5OH + O2 == H2O + CO2');
#say $pCOMMAND.parse('K4Fe(CN)6');
#say $pCOMMAND.parse('(NH4)20SO14');
#say $pCOMMAND.parse('K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO');


say "=" x 60;

say chemical-element('Oxygen', 'Russian');
say chemical-element(12, 'Russian');
say chemical-element('Хлор', 'Japanese');
say chemical-element('Хлор', 'Spanish');
say chemical-element(['Хлор', 'Кислород', 'Водород', 'Oxygen'], 'Spanish');


say "=" x 60;

my @testCommands = ['Cl', 'O', 102, 'Actinium', 'ガリウム', 'берилий'];

say chemical-symbol(@testCommands);
say chemical-element(@testCommands);
say atomic-number(@testCommands);
say atomic-weight(@testCommands);
say chemical-element-data(@testCommands);

say molecular-mass(<Cl H2O SO2>):p;

for @testCommands -> $c {
    say "-" x 30;
    my $res = chemical-element-data($c):abbr;
    say $c, ' : ', $res;
}


#say "=" x 60;
#
#my @testCommands = <Cl SO42 Al2(CO3)3 (Cl4NH3)3(Cl6)2, C2H5OH+O2=H2O+CO2>;
#
#my @targets = ('WL-System');
#
#for @testCommands -> $c {
#    say "-" x 30;
#    say $c;
#    my $start = now;
#    my $res = molecular-mass($c);
#    say "time:", now - $start;
#    say $res;
#}
