# Raku Chemistry::Stoichiometry

[![Build Status](https://travis-ci.com/antononcube/Raku-Chemistry-Stoichiometry.svg?branch=main)](https://travis-ci.com/antononcube/Raku-Chemistry-Stoichiometry)

## In brief

Raku package for Stoichiometry procedures and related data.

The package 
[Chemistry::Elements](https://github.com/briandfoy/perl6-chemistry-elements)
developed by Brian D. Foy, [BF1], has functions to convert
between chemical names, symbols/abbreviations, and atomic numbers. 

------

## Installation

To install the package in Raku with [zef installer](https://github.com/ugexe/zef):

```
zef install https://github.com/antononcube/Raku-Chemistry-Stoichiometry.git
```

------

## Usage examples

### Element data

Element data of one or several elements can be obtained with the function `chemical-element-data`:

```perl6
use Chemistry::Stoichiometry;
say chemical-element-data('Cl');
# {Abbreviation => Cl, AtomicNumber => 17, AtomicWeight => 35.45, Block => p, Group => 17, Name => chlorine, Period => 3, Series => Halogen, StandardName => Chlorine}

say chemical-element-data(['H', 'Li', 'Na', 'K', 'Rb', 'Cs', 'Fr']);
# ({Abbreviation => H, AtomicNumber => 1, AtomicWeight => 1.008, Block => s, Group => 1, Name => hydrogen, Period => 1, Series => Nonmetal, StandardName => Hydrogen} {Abbreviation => Li, AtomicNumber => 3, AtomicWeight => 6.94, Block => s, Group => 1, Name => lithium, Period => 2, Series => AlkaliMetal, StandardName => Lithium} {Abbreviation => Na, AtomicNumber => 11, AtomicWeight => 22.98976928, Block => s, Group => 1, Name => sodium, Period => 3, Series => AlkaliMetal, StandardName => Sodium} {Abbreviation => K, AtomicNumber => 19, AtomicWeight => 39.0983, Block => s, Group => 1, Name => potassium, Period => 4, Series => AlkaliMetal, StandardName => Potassium} {Abbreviation => Rb, AtomicNumber => 37, AtomicWeight => 85.4678, Block => s, Group => 1, Name => rubidium, Period => 5, Series => AlkaliMetal, StandardName => Rubidium} {Abbreviation => Cs, AtomicNumber => 55, AtomicWeight => 132.90545196, Block => s, Group => 1, Name => cesium, Period => 6, Series => AlkaliMetal, StandardName => Cesium} {Abbreviation => Fr, AtomicNumber => 87, AtomicWeight => 223.0, Block => s, Group => 1, Name => francium, Period => 7, Series => AlkaliMetal, StandardName => Francium})
```

### Element names

```perl6
say chemical-element('Cl');
# Chlorine

say chemical-element('Cl', 'Russian');
# Хлор
```

Chemical element names can be obtained using the function `chemical-element-data` with the adverb `:name`:

```perl6
say chemical-element-data('Cl'):name;
# Chlorine
```

### Element symbols / abbreviations

```perl6
say chemical-symbol('oxygen');   # 'O' from English
# O

say chemical-symbol('кислород'); # 'O' from Bulgarian
# O
```

Chemical element abbreviations can be obtained using the function `chemical-element-data` with the adverb `:abbr`:

```perl6
say chemical-element-data('oxygen'):symbol;         # 'O' from English
# O

say chemical-element-data('кислород'):abbr;         # 'O' from Bulgarian
# O
```

Note, that `chemical-element` will automatically detect the language.

### Atomic numbers

```perl6
say atomic-number('Cl');
#17

say atomic-number('actinium');  # from the English name of Ac
# 89

say atomic-number('берилий');   # from the Bulgarian name of Be
# 4
```

Alternatively, `chemical-element-data` can be used with the adverb `:atomic-number`:

```perl6
say chemical-element-data('Cl'):number;
# 17

say chemical-element-data('Cl'):atomic-number;
# 17
```

### Atomic weight

```perl6
say atomic-weight('Se');
# 78.971

say atomic-weight('ガリウム');  # from the Japanese name of Ga
# 69.723
```

Alternatively, `chemical-element-data` can be used with the adverb `:atomic-weight`:

```perl6
say chemical-element-data('Cl'):weight;
# 35.45

say chemical-element-data('Cl'):atomic-weight;
# 35.45
```

### Molecular mass

```perl6
say molecular-mass('SO2');
# 64.058

say molecular-mass('C2H5OH + O2 = H2O + CO2');
# 78.06700000000001 => 62.024
```

### Equation balancing

```perl6
say balance-chemical-equation('C2H5OH + O2 = H2O + CO2');
# [1*C2H5OH + 3*O2 = 2*CO2 + 3*H2O]

say balance-chemical-equation( 'K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO' );
# [6*H2O + 6*H2SO4 + 1*K4Fe(CN)6 = 3*(NH4)2SO4 + 6*CO + 1*FeSO4 + 2*K2SO4]
```

## TODO

1. [ ] Extensive tests:
   
   - [ ] Chemical data retrieval

   - [ ] Chemical compound formulae parser

   - [ ] Molecular mass calculation
   
   - [ ] Chemical equation balancing
    
2. [ ] Chemical element names translation function. 
       (Say, from Bulgarian to Persian.)

3. [ ] Extensive documentation.

4. [ ] Handling of semicolon separated input. 
 
   - [ ] For the data functions. E.g. `atomic-weight('Cl; O; Mn')`.
    
   - [ ] For the parser-interpreter functions. E.g. `molecular-mass('FeSO4; H2O; CO2')`.

5. [ ] Recognition of chemical compound names.

   - This requires the development of a separate chemical entities package.

6. [ ] Element data in more languages.


## References

[BF1] Brian D. Foy,
[Chemistry::Elements Raku package](https://github.com/briandfoy/perl6-chemistry-elements),
(2016-2018),
[GitHub/briandfoy](https://github.com/briandfoy).
