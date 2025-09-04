=begin pod

=head1 Chemistry::Stoichiometry

C<Chemistry::Stoichiometry> package has grammar and action classes for the parsing and
interpretation of stoichiometry formulas and equations.

=head1 Synopsis

    use Chemistry::Stoichiometry;
    my $rcode = ToStoichiometryCode('Argentina');

=end pod

unit module Chemistry::Stoichiometry;

use Chemistry::Stoichiometry::Grammar;
use Chemistry::Stoichiometry::Actions::EquationBalance;
use Chemistry::Stoichiometry::Actions::MolecularMass;
use Chemistry::Stoichiometry::Actions::WL::System;

#-----------------------------------------------------------
my Chemistry::Stoichiometry::ResourceAccess $resources.instance;

#-----------------------------------------------------------
my %targetToAction =
    "Mathematica"      => Chemistry::Stoichiometry::Actions::WL::System,
    "WL"               => Chemistry::Stoichiometry::Actions::WL::System,
    "WL-System"        => Chemistry::Stoichiometry::Actions::WL::System;

my %targetToSeparator{Str} =
    "Julia"            => "\n",
    "Julia-DataFrames" => "\n",
    "R"                => " ;\n",
    "Mathematica"      => "\n",
    "WL"               => ";\n",
    "WL-System"        => ";\n",
    "WL-Entity"        => ";\n",
    "Bulgarian"        => "\n";

#-----------------------------------------------------------
sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
#|( Convert chemical element names, abbreviations, or atomic numbers int atomic numbers.
    * C<$num> A string, an integer, or a list of strings and/or integers to be converted.
)
proto atomic-number(|) is export {*}

multi atomic-number(@specs) {
    @specs.map({ atomic-number($_) })
}

multi atomic-number($spec) {
    chemical-element-data($spec):atomic-number
}

#-----------------------------------------------------------
#|( Convert chemical element names, abbreviations, or atomic numbers int atomic weights.
    * C<$num> A string, an integer, or a list of strings and/or integers to be converted.
)
proto atomic-weight(|) is export {*}

multi atomic-weight(@specs) {
    @specs.map({ atomic-weight($_) })
}

multi atomic-weight($spec) {
    chemical-element-data($spec):atomic-weight
}

#-----------------------------------------------------------
sub balance-chemical-equation(Str:D $spec ) is export {
    Chemistry::Stoichiometry::Grammar.parse($spec, actions => Chemistry::Stoichiometry::Actions::EquationBalance).made;
}

#-----------------------------------------------------------
#|( Convert chemical element names or atomic numbers into chemical element symbols (abbreviations.)
    * C<$num> A string, an integer, or a list of strings and/or integers to be converted.
)
proto chemical-symbol(|) is export {*}

multi chemical-symbol(@specs) {
    @specs.map({ chemical-symbol($_) })
}

multi chemical-symbol($spec) {
    chemical-element-data($spec):symbol
}

#-----------------------------------------------------------
#|( Convert chemical element abbreviations or atomic numbers into chemical element standard names.
    * C<$spec> A string, an integer, or a list of strings and/or integers to be converted.
    * C<$language> Which language the output to be in?
)
proto chemical-element(|) is export {*}
#| The first argument can be in a language other than English.

multi chemical-element(@specs, Str:D $language = 'English') {
    @specs.map({ chemical-element($_, $language) })
}

multi chemical-element($spec, Str:D $language = 'English') is export {
    if $language.lc eq 'english' {
        chemical-element-data($spec):standard-name
    } else {
        $resources.get-standard-name($spec, $language)
    }
}

#-----------------------------------------------------------
#|( Convert chemical element names, abbreviations, or atomic numbers into chemical element data records.
    * C<$num> A string, an integer, or a list of strings and/or integers to be converted.
    * C<$symbol> Adverb to return symbol.
    * C<$abbr> Adverb to return symbol. (Same as C<$symbol>.)
    * C<$name> Adverb to return standard name.
    * C<$standard-name> Adverb to return standard name. (Same as C<$name>.)
    * C<$weight> Adverb to return atomic weight.
    * C<$atomic-weight> Adverb to return atomic weight. (Same as C<$weight>.)
    * C<$number> Adverb to return atomic number.
    * C<$atomic-number> Adverb to return atomic number. (Same as C<$number>.)
)
proto sub chemical-element-data(|) is export {*}

multi sub chemical-element-data() {
    $resources.get-element-data()
}

multi sub chemical-element-data(@specs,
                            Bool:D :symbol(:$abbr) = False, #= return symbol
                            Bool:D :name(:$standard-name) = False, #= return standard name
                            Bool:D :weight(:$atomic-weight) = False, #= return atomic weight
                            Bool:D :number(:$atomic-number) = False, #= return atomic number
                            ) {

    @specs.map({ chemical-element-data($_, :$abbr, :$standard-name, :$atomic-weight, :$atomic-number) })
}

multi sub chemical-element-data($spec,
                            Bool:D :symbol(:$abbr) = False, #= return symbol
                            Bool:D :name(:$standard-name) = False, #= return standard name
                            Bool:D :weight(:$atomic-weight) = False, #= return atomic weight
                            Bool:D :number(:$atomic-number) = False, #= return atomic number
                            ) {

    my $stdName = $resources.get-standard-name($spec);
    if not $stdName.defined { return Nil }

    my $data = $resources.get-element-data( $stdName );

    if $abbr             { $data<Abbreviation> }
    elsif $standard-name { $data<StandardName> }
    elsif $atomic-weight { $data<AtomicWeight> }
    elsif $atomic-number { $data<AtomicNumber> }
    else                 { $data }
}

#-----------------------------------------------------------
#|( Convert chemical compound formula (molecule) into molecule mass.
    * C<$specs | @specs> A string, or a list of strings.
    * C<$:p> Should the result be a list of pairs or not? (If the first argument is positional, C<@specs>.)
)
proto molecular-mass(|) is export {*}

multi molecular-mass(@specs, Bool :$p = False) {
    if $p {
        @specs.map({ $_ => molecular-mass($_) })
    } else {
        @specs.map({ molecular-mass($_) })
    }
}

multi molecular-mass(Str:D $spec ) is export {
    Chemistry::Stoichiometry::Grammar.parse($spec, actions => Chemistry::Stoichiometry::Actions::MolecularMass).made;
}