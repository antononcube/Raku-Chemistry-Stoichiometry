# Raku Chemistry::Stoichiometry

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
say chemical-element-data(['H', 'Li', 'Na', 'K', 'Rb', 'Cs', 'Fr']);
```

### Element names

```perl6
say chemical-element('Cl');
say chemical-element('Cl', 'Russian');
```

Chemical element names can be obtained using the function `chemical-element-data` with the adverb `:name`:

```perl6
say chemical-element-data('Cl', 'Persian'):name;
```

### Element symbols / abbreviations

```perl6
say chemical-symbol('oxygen');   # 'O' from English
say chemical-symbol('кислород'); # 'O' from Bulgarian
```

Chemical element abbreviations can be obtained using the function `chemical-element-data` with the adverb `:abbr`:

```perl6
say chemical-element-data('oxygen'):symbol;         # 'O' from English
say chemical-element-data('кислород'):abbr;         # 'O' from Bulgarian
```

Note, that `chemical-element` will automatically detect the language.

### Atomic numbers

```perl6
say atomic-number('Cl');
say atomic-number('actinium');  # from the English name of Ac
say atomic-number('берилий');   # from the Bulgarian name of Be
```

Alternatively, `chemical-element-data` can be used with the adverb `:atomic-number`:

```perl6
say chemical-element-data('Cl'):number;
say chemical-element-data('Cl'):atomic-number;
```

### Atomic weight

```perl6
say atomic-weight('Se');
say atomic-weight('ガリウム');  # from the Japanese name of Ga
```

Alternatively, `chemical-element-data` can be used with the adverb `:atomic-weight`:

```perl6
say chemical-element-data('Cl'):weight;
say chemical-element-data('Cl'):atomic-weight;
```

### Molecular mass

```perl6
say molecular-mass('SO2');
say molecular-mass('C2H5OH + O2 = H2O + CO2');
```

### Equation balancing

```perl6
say balance-chemical-equation('C2H5OH + O2 = H2O + CO2');
```

## References

[BF1] Brian D. Foy,
[Chemistry::Elements Raku package](https://github.com/briandfoy/perl6-chemistry-elements),
(2016-2018),
[GitHub/briandfoy](https://github.com/briandfoy).
