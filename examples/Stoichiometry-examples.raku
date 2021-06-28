use lib './lib';
use lib '.';
use Chemistry::Stoichiometry;
use Chemistry::Stoichiometry::Actions::MolecularMass;
use Chemistry::Stoichiometry::Actions::EquationMatrix;
use Chemistry::Stoichiometry::Actions::EquationBalance;

say "=" x 60;
say 'Chemical elements translations to different languages';
say "-" x 60;

say chemical-element('Oxygen', 'Russian');
say chemical-element(12, 'Russian');
say chemical-element('Хлор', 'Japanese');
say chemical-element(['Хлор', 'Кислород', 'Водород', 'Oxygen'], 'Spanish');


say "=" x 60;
say 'Element data retrieval for multiplple elements';
say "-" x 60;

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

say "=" x 60;
say 'Molecular mass';

@testCommands = <Cl SO42 Al2(CO3)3 (Cl4NH3)3(Cl6)2, C2H5OH+O2=H2O+CO2>;

for @testCommands -> $c {
    say "-" x 30;
    say $c;
    my $start = now;
    my $res = molecular-mass($c);
    say "time:", now - $start;
    say $res;
}

say "=" x 60;
say 'Chemical equation balancing';
say "-" x 60;

say balance-chemical-equation( 'K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO' ).raku;
