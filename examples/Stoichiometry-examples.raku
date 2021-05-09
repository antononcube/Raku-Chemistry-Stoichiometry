use lib './lib';
use lib '.';
use Chemistry::Stoichiometry;
use Chemistry::Stoichiometry::ResourceAccess;

my $pCOMMAND = Chemistry::Stoichiometry::Grammar;

#use Grammar::Tracer;

say $pCOMMAND.parse('C2H5OH');
say $pCOMMAND.parse('C2H5OH + O2 == H2O + CO2');
#say $pCOMMAND.parse('K4Fe(CN)6');
#say $pCOMMAND.parse('(NH4)20SO14');
#say $pCOMMAND.parse('K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO');


say "=" x 60;

my @testCommands = <Cl SO42 Al2(CO3)3 (Cl4NH3)3(Cl6)2, C2H5OH+O2=H2O+CO2>;

my @targets = ('WL-System');

for @testCommands -> $c {
    say "=" x 30;
    say $c;
    for @targets -> $t {
        say '-' x 30;
        say $t;
        say '-' x 30;
        my $start = now;
        #my $res = ToStoichiometryCode($c, $t);
        my $res = $pCOMMAND.parse($c);
        say "time:", now - $start;
        say $res;
    }
}
