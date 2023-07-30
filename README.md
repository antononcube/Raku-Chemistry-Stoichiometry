# Raku Chemistry::Stoichiometry

[![Build Status](https://travis-ci.com/antononcube/Raku-Chemistry-Stoichiometry.svg?branch=main)](https://travis-ci.com/antononcube/Raku-Chemistry-Stoichiometry)
[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)

:bulgaria: 🇨🇳 🇨🇿 🇬🇧 🇩🇪 :greece: 🇯🇵 🇰🇷 :iran: :poland: 🇵🇹 🇷🇺 🇪🇸

## Introduction

This repository is with Raku package for Stoichiometry procedures and related data.
The primary functionalities are:

- Calculation of molecular masses for chemical compound formulas

- Chemical equations balancing

- Multi-language support

Here are corresponding examples:

```perl6
use Chemistry::Stoichiometry;

say molecular-mass('SO2');
```
```
# 64.058
```

```perl6
say balance-chemical-equation('C2H5OH + O2 = H2O + CO2');
```
```
# [1*C2H5OH + 3*O2 -> 2*CO2 + 3*H2O]
```

The package has also functions for chemical element data retrieval
and functions that convert between chemical names, symbols/abbreviations, and atomic numbers. 

Here are a couple of examples:

```perl6
say atomic-number('actinium');
```
```
# 89
```

```perl6
say chemical-symbol('ガリウム');
```
```
# Ga
```

**Remark:** Multiple languages can be used for the names of the chemical elements. 
The corresponding functions automatically detect the language. 

**Remark:** At this point the package has standard element names in the following languages:

```perl6
my Chemistry::Stoichiometry::ResourceAccess $resources.instance;
say $resources.get-language-names-data.keys.sort;
```
```
# (Arabic Bulgarian Chinese Czech English German Greek Japanese Korean Persian Polish Portuguese Russian Spanish)
```

Adding new languages can be easily done by adding CSV files into the 
[resources](./resources) directory.

### Related work

The package 
["Chemistry::Elements"](https://github.com/briandfoy/perl6-chemistry-elements)
developed by Brian D. Foy, [BF1], also has functions that convert
between chemical names, symbols/abbreviations, and atomic numbers. 
(Several languages are supported.) 

Mathematica / Wolfram Language (WL) has the function 
[`ElementData`](https://reference.wolfram.com/language/ref/ElementData.html), [WRI1]. 

In 2007 I wrote the original versions of the chemical equation balancing and 
molecular functionalities in 
[WolframAlpha](https://www.wolframalpha.com).
See for example 
[this output](https://www.wolframalpha.com/input/?i=C2H5OH+%2B+O2+%3D+H2O+%2B+CO2).

------

## Installation

Package installations from both sources use [zef installer](https://github.com/ugexe/zef)
(which should be bundled with the "standard" [Rakudo](https://rakudo.org) installation file.)

To install the package from [Zef ecosystem](https://raku.land)
use the shell command:

```
zef install Chemistry::Stoichiometry
```

To install the package from the GitHub repository use the shell command:

```
zef install https://github.com/antononcube/Raku-Chemistry-Stoichiometry.git
```

------

## Element data retrieval

### Element data records

Element data of one or several elements can be obtained with the function `chemical-element-data`:

```perl6
say chemical-element-data('Cl');
```
```
# {Abbreviation => Cl, AtomicNumber => 17, AtomicWeight => 35.45, Block => p, Group => 17, Name => chlorine, Period => 3, Series => Halogen, StandardName => Chlorine}
```

```perl6
.say for chemical-element-data(['H', 'Li', 'Na', 'K', 'Rb', 'Cs', 'Fr']);
```
```
# {Abbreviation => H, AtomicNumber => 1, AtomicWeight => 1.008, Block => s, Group => 1, Name => hydrogen, Period => 1, Series => Nonmetal, StandardName => Hydrogen}
# {Abbreviation => Li, AtomicNumber => 3, AtomicWeight => 6.94, Block => s, Group => 1, Name => lithium, Period => 2, Series => AlkaliMetal, StandardName => Lithium}
# {Abbreviation => Na, AtomicNumber => 11, AtomicWeight => 22.98976928, Block => s, Group => 1, Name => sodium, Period => 3, Series => AlkaliMetal, StandardName => Sodium}
# {Abbreviation => K, AtomicNumber => 19, AtomicWeight => 39.0983, Block => s, Group => 1, Name => potassium, Period => 4, Series => AlkaliMetal, StandardName => Potassium}
# {Abbreviation => Rb, AtomicNumber => 37, AtomicWeight => 85.4678, Block => s, Group => 1, Name => rubidium, Period => 5, Series => AlkaliMetal, StandardName => Rubidium}
# {Abbreviation => Cs, AtomicNumber => 55, AtomicWeight => 132.90545196, Block => s, Group => 1, Name => cesium, Period => 6, Series => AlkaliMetal, StandardName => Cesium}
# {Abbreviation => Fr, AtomicNumber => 87, AtomicWeight => 223, Block => s, Group => 1, Name => francium, Period => 7, Series => AlkaliMetal, StandardName => Francium}
```

### Element names

```perl6
say chemical-element('Cl');
```
```
# Chlorine
```

```perl6
say chemical-element('Cl', 'Russian');
```
```
# Хлор
```

Chemical element names can be obtained using the function `chemical-element-data` with the adverbs
`:name` or `:standard-name`:

```perl6
say chemical-element-data('Cl'):name;
```
```
# Chlorine
```

```perl6
say chemical-element-data('Cl'):standard-name;
```
```
# Chlorine
```

### Element symbols / abbreviations

```perl6
say chemical-symbol('oxygen');   # 'O' from English
```
```
# O
```

```perl6
say chemical-symbol('кислород'); # 'O' from Bulgarian
```
```
# O
```

Chemical element abbreviations can be obtained using the function `chemical-element-data` with the adverbs
`:symbol` or `:abbr`:

```perl6
say chemical-element-data('oxygen'):symbol;         # 'O' from English
```
```
# O
```

```perl6
say chemical-element-data('кислород'):abbr;         # 'O' from Bulgarian
```
```
# O
```

Note, that `chemical-element` will automatically detect the language.

### Atomic numbers

```perl6
say atomic-number('Cl');
```
```
# 17
```

```perl6
say atomic-number('actinium');  # from the English name of Ac
```
```
# 89
```

```perl6
say atomic-number('берилий');   # from the Bulgarian name of Be
```
```
# 4
```

Alternatively, `chemical-element-data` can be used with the adverbs `:number` or `:atomic-number`:

```perl6
say chemical-element-data('Cl'):number;
```
```
# 17
```

```perl6
say chemical-element-data('Cl'):atomic-number;
```
```
# 17
```

### Atomic weights

```perl6
say atomic-weight('Se');
```
```
# 78.971
```

```perl6
say atomic-weight('ガリウム');  # from the Japanese name of Ga
```
```
# 69.723
```

Alternatively, `chemical-element-data` can be used with the adverbs `:weight` or `:atomic-weight`:

```perl6
say chemical-element-data('Cl'):weight;
```
```
# 35.45
```

```perl6
say chemical-element-data('Cl'):atomic-weight;
```
```
# 35.45
```

------

## Stoichiometry procedures

The functions `molecular-mass` and `balance-chemical-equation` are based on a parser
for 
[Simplified Molecular-Input Line-Entry System (SMILES)](https://en.wikipedia.org/wiki/Simplified_molecular-input_line-entry_system), 
[OS1]. 

### Molecular mass

Molecular mass for a compound:

```perl6
say molecular-mass('SO2');
```
```
# 64.058
```

Molecular masses of the sides of a chemical equation:

```perl6
say molecular-mass('C2H5OH + O2 -> H2O + CO2');
```
```
# 78.06700000000001 => 62.024
```

Note that the masses in the output above are different because the equation is not balanced.

### Equation balancing

For a given chemical equation the function `balance-chemical-equation` returns a list of balanced equations.

```perl6
say balance-chemical-equation('C2H5OH + O2 = H2O + CO2');
```
```
# [1*C2H5OH + 3*O2 -> 2*CO2 + 3*H2O]
```

```perl6
say balance-chemical-equation( 'K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO' );
```
```
# [6*H2O + 6*H2SO4 + 1*K4Fe(CN)6 -> 3*(NH4)2SO4 + 6*CO + 1*FeSO4 + 2*K2SO4]
```

**Remark:** The result of the balancing is a list because certain chemical equations 
can be balanced in several ways corresponding to different reactions.

------

## Abstract syntax tree

Here is a way to get Abstract Syntax Tree of a (parse-able) molecule formula:

```perl6
my $cf = 'K4Fe(CN)6';
say Chemistry::Stoichiometry::Grammar.parse( $cf );
```
```
# ｢K4Fe(CN)6｣
#  mult-molecule => ｢K4Fe(CN)6｣
#   molecule => ｢K4Fe(CN)6｣
#    sub-molecule => ｢K4｣
#     chemical-element-mult => ｢K4｣
#      chemical-element => ｢K｣
#       K-stoichiometry => ｢K｣
#      number => ｢4｣
#    sub-molecule => ｢Fe｣
#     chemical-element => ｢Fe｣
#      Fe-stoichiometry => ｢Fe｣
#    sub-molecule => ｢(CN)6｣
#     group-mult => ｢(CN)6｣
#      group => ｢(CN)｣
#       molecule => ｢CN｣
#        sub-molecule => ｢C｣
#         chemical-element => ｢C｣
#          C-stoichiometry => ｢C｣
#        sub-molecule => ｢N｣
#         chemical-element => ｢N｣
#          N-stoichiometry => ｢N｣
#      number => ｢6｣
```

------

## TODO

In order of importance, most important are first:

1. [ ] TODO Extensive tests:
   
   - [ ] TODO Chemical data retrieval

   - [ ] TODO Chemical compound formulae parser

   - [ ] TODO Molecular mass calculation
   
   - [ ] TODO Chemical equation balancing
    
2. [X] DONE Chemical element names translation function. 
       (Say, from Bulgarian to Persian.)
   
3. [ ] TODO Inverse look-up from atomic weight to chemical element(s).

4. [ ] TODO Extensive documentation.

5. [ ] TODO Handling of semicolon separated input. 
 
   - [ ] TODO For the data functions. E.g. `atomic-weight('Cl; O; Mn')`.
    
   - [ ] TODO For the parser-interpreter functions. E.g. `molecular-mass('FeSO4; H2O; CO2')`.

6. [X] DONE Parsing of (pre-)balanced chemical equations. 
   
7. [ ] TODO Recognition of chemical compound names.

   - This requires the development of a separate chemical entities package.

8. [ ] TODO Element data in more languages.

   - [X] DONE Chinese Traditional
   - [ ] TODO Chinese Simplified
   - [X] DONE Czech
   - [X] DONE Korean
   - [X] DONE Portuguese (PT)
   - [ ] TODO  Portuguese (BR)
   - [ ] TODO Other

------

## References

[BF1] Brian D. Foy,
[Chemistry::Elements Raku package](https://github.com/briandfoy/perl6-chemistry-elements),
(2016-2018),
[GitHub/briandfoy](https://github.com/briandfoy).

[CJ1] Craig A. James,
[OpenSMILES specification](http://opensmiles.org/opensmiles.html),
(2007-2016),
[OpenSMILES.org](http://opensmiles.org).

[WRI1] Wolfram Research, 
[ElementData, Wolfram Language function](https://reference.wolfram.com/language/ref/ElementData.html),
(2007), (updated 2014),
[Wolfram Language System Documentation Center](https://reference.wolfram.com).