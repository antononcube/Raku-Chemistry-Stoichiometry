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

```perl6
say balance-chemical-equation('C2H5OH + O2 = H2O + CO2');
```

The package has also functions for chemical element data retrieval
and functions that convert between chemical names, symbols/abbreviations, and atomic numbers. 

Here are a couple of examples:

```perl6
say atomic-number('actinium');
```

```perl6
say chemical-symbol('ガリウム');
```

**Remark:** Multiple languages can be used for the names of the chemical elements. 
The corresponding functions automatically detect the language. 

**Remark:** At this point the package has standard element names in the following languages:

```perl6
my Chemistry::Stoichiometry::ResourceAccess $resources.instance;
say $resources.get-language-names-data.keys.sort;
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

```perl6
.say for chemical-element-data(['H', 'Li', 'Na', 'K', 'Rb', 'Cs', 'Fr']);
```

### Element names

```perl6
say chemical-element('Cl');
```

```perl6
say chemical-element('Cl', 'Russian');
```

Chemical element names can be obtained using the function `chemical-element-data` with the adverbs
`:name` or `:standard-name`:

```perl6
say chemical-element-data('Cl'):name;
```

```perl6
say chemical-element-data('Cl'):standard-name;
```

### Element symbols / abbreviations

```perl6
say chemical-symbol('oxygen');   # 'O' from English
```

```perl6
say chemical-symbol('кислород'); # 'O' from Bulgarian
```

Chemical element abbreviations can be obtained using the function `chemical-element-data` with the adverbs
`:symbol` or `:abbr`:

```perl6
say chemical-element-data('oxygen'):symbol;         # 'O' from English
```

```perl6
say chemical-element-data('кислород'):abbr;         # 'O' from Bulgarian
```

Note, that `chemical-element` will automatically detect the language.

### Atomic numbers

```perl6
say atomic-number('Cl');
```

```perl6
say atomic-number('actinium');  # from the English name of Ac
```

```perl6
say atomic-number('берилий');   # from the Bulgarian name of Be
```

Alternatively, `chemical-element-data` can be used with the adverbs `:number` or `:atomic-number`:

```perl6
say chemical-element-data('Cl'):number;
```

```perl6
say chemical-element-data('Cl'):atomic-number;
```

### Atomic weights

```perl6
say atomic-weight('Se');
```

```perl6
say atomic-weight('ガリウム');  # from the Japanese name of Ga
```

Alternatively, `chemical-element-data` can be used with the adverbs `:weight` or `:atomic-weight`:

```perl6
say chemical-element-data('Cl'):weight;
```

```perl6
say chemical-element-data('Cl'):atomic-weight;
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

Molecular masses of the sides of a chemical equation:

```perl6
say molecular-mass('C2H5OH + O2 -> H2O + CO2');
```

Note that the masses in the output above are different because the equation is not balanced.

### Equation balancing

For a given chemical equation the function `balance-chemical-equation` returns a list of balanced equations.

```perl6
say balance-chemical-equation('C2H5OH + O2 = H2O + CO2');
```

```perl6
say balance-chemical-equation( 'K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO' );
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