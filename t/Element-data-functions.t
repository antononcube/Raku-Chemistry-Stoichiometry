use Test;

use lib './lib';
use lib '.';

use Chemistry::Stoichiometry;

plan 5;

my @testCommands = ['Cl', 'O', 102, 'Actinium', 'ガリウム', 'берилий'];

is-deeply chemical-symbol(@testCommands), <Cl O No Ac Ga Be>, 'chemical-symbol(@testCommands)';

is-deeply chemical-element(@testCommands), <Chlorine Oxygen Nobelium Actinium Gallium Beryllium>, 'chemical-element(@testCommands)';

is-deeply atomic-number(@testCommands), ('17', '8', '102', '89', '31', '4'), 'atomic-number(@testCommands)';

is-deeply atomic-weight(@testCommands), ('35.45', '15.999', '259.0', '227.0', '69.723', '9.0121831'), 'atomic-weight(@testCommands)';

is chemical-element-data(@testCommands).WHAT,
        Seq,
        'chemical-element-data(@testCommands)';


done-testing;
