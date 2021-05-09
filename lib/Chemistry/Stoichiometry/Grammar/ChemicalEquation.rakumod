use v6;

# My previously made EBNF using the Mathematica package FunctionalParsers.m
# uses left-recursion. I had to modify it in order to have a working
# Raku implementation -- see <molecule>.

# SMILES grammar, though, is somewhat simpler than the one mentioned above.

# Below <smile> is implemented with a grammar based on this article:
# https://depth-first.com/articles/2020/04/20/smiles-formal-grammar/

# See also "OpenSMILES specification":
# http://opensmiles.org/opensmiles.html

use Chemistry::Stoichiometry::ResourceAccess;

my Chemistry::Stoichiometry::ResourceAccess $resources.instance;

role Chemistry::Stoichiometry::Grammar::ChemicalEquation {

    # General tokens
    token bond-symbol  { '-' | '=' | '#' | '$' | '/' | '\\' }
    token dot-symbol   { '.' }
    token hv-sunlight  { 'hν' | 'hv' }
    token number       { \d+ }
    token yield-symbol { '->' | '==' | '=' | '→' }

    # Left recursion definition Raku cannot handle
    #  rule molecule     { <sub-molecule> | <replicated> | <connected> }
    #  rule sub-molecule { <chemical-element> | '(' <molecule> ')' }
    #  rule replicated   { <molecule> <number> | <molecule> '_' <number> }
    #  rule smr          { <replicated> | <sub-molecule> }
    #  rule connected    { <smr>+ }

    # Proper sub-grouping
    regex molecule     { <sub-molecule>+ }
    regex sub-molecule { <chemical-element-mult> || <chemical-element> || <group-mult> || <group> }
    regex chemical-element-mult { <chemical-element> <number> }
    regex group        { '(' <molecule> ')' }
    regex group-mult   { <group> <number> }

    # Chemical equation
    regex mixture-term { <molecule> | <hv-sunlight> }
    regex mixture-plus { \h* '+' \h* }
    regex mixture { <mixture-term>+ % <.mixture-plus> }
    regex chemical-equation { <lhs=.mixture> \h* <.yield-symbol> \h* <rhs=.mixture> }

    # Just a parser form SMILE expressions. (Not useful for computations.)
    regex smile    { [ <chemical-element> | <branch> ] [ <chain> | <branch> ]* }
    regex chain    { [ <dot-symbol> <chemical-element> | <bond-symbol>? [ <chemical-element> | <number> ] ]+ }
    regex branch   { '(' [ [ <bond-symbol> | <dot-symbol> ]? <smile> ]+ ')' }
}