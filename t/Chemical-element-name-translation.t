use Test;

use lib './lib';
use lib '.';

use Chemistry::Stoichiometry;

plan 6;

## 1
is-deeply chemical-element('Oxygen', 'Russian'),
        'Кислород',
        "chemical-element('Oxygen', 'Russian')";

## 2
is-deeply chemical-element(12, 'Russian'),
        'Магний',
        "chemical-element(12, 'Russian')";

## 3
is-deeply chemical-element('Хлор', 'Japanese'),
        '塩素',
        "chemical-element('Хлор', 'Japanese')";

## 4
is-deeply chemical-element('Хлор', 'Spanish'),
        'Cloro',
        "chemical-element('Хлор', 'Spanish')";

## 5
is-deeply chemical-element(['Хлор', 'Кислород', 'Водород', 'Oxygen'], 'Spanish'),
        <Cloro Oxígeno Hidrógeno Oxígeno>,
        'chemical-element-data(@testCommands)';

## 6
is-deeply chemical-element(<Oxygen Argon Carbon>),
        <Oxygen Argon Carbon>,
        "chemical-element(<Oxygen, Argon, Carbon>)";

done-testing;
