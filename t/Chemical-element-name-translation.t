use Test;

use lib './lib';
use lib '.';

use Chemistry::Stoichiometry;

plan 11;

## 1
is-deeply chemical-element('Хлор', 'Bulgarian'),
        'Хлор',
        "chemical-element('Хлор', 'Bulgarian')";

## 2
is-deeply chemical-element('Хлор', 'German'),
        'Chlor',
        "chemical-element('Хлор', 'German')";

## 3
is-deeply chemical-element('Хлор', 'Greek'),
        'Χλωριο',
        "chemical-element('Хлор', 'Greek')";

## 4
is-deeply chemical-element('Хлор', 'Japanese'),
        '塩素',
        "chemical-element('Хлор', 'Japanese')";

## 5
is-deeply chemical-element(12, 'Russian'),
        'Магний',
        "chemical-element(12, 'Russian')";

## 6
is-deeply chemical-element('Хлор', 'Persian'),
        'کلر',
        "chemical-element('Хлор', 'Persian')";

## 7
is-deeply chemical-element('Хлор', 'Polish'),
        'Chlor',
        "chemical-element('Хлор', 'Polish')";

## 8
is-deeply chemical-element('Хлор', 'Spanish'),
        'Cloro',
        "chemical-element('Хлор', 'Spanish')";

## 9
is-deeply chemical-element('Oxygen', 'Russian'),
        'Кислород',
        "chemical-element('Oxygen', 'Russian')";

## 10
is-deeply chemical-element(['Хлор', 'Кислород', 'Водород', 'Oxygen'], 'Spanish'),
        <Cloro Oxígeno Hidrógeno Oxígeno>,
        'chemical-element-data(@testCommands)';

## 11
is-deeply chemical-element(<Oxygen Argon Carbon>),
        <Oxygen Argon Carbon>,
        "chemical-element(<Oxygen, Argon, Carbon>)";

done-testing;
