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
proto chemical-element-data(|) is export {*}

multi chemical-element-data() {
    $resources.get-element-data()
}

multi chemical-element-data(@specs,
                          Bool :$symbol, Bool :$abbr,
                          Bool :$name,   Bool :$standard-name,
                          Bool :$weight, Bool :$atomic-weight,
                          Bool :$number, Bool :$atomic-number) {

    @specs.map({ chemical-element-data($_, :$symbol, :$abbr, :$name, :$standard-name, :$weight, :$atomic-weight, :$number, :$atomic-number) })
}

multi chemical-element-data($spec,
                          Bool :$symbol, Bool :$abbr,
                          Bool :$name,   Bool :$standard-name,
                          Bool :$weight, Bool :$atomic-weight,
                          Bool :$number, Bool :$atomic-number) {

    my $stdName = $resources.get-standard-name($spec);
    if not $stdName.defined { return Nil }

    my $data = $resources.get-element-data( $stdName );

    if $symbol or $abbr             { $data<Abbreviation> }
    elsif $name or $standard-name   { $data<StandardName> }
    elsif $weight or $atomic-weight { $data<AtomicWeight> }
    elsif $number or $atomic-number { $data<AtomicNumber> }
    else                            { $data }
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

#-----------------------------------------------------------
proto ToStoichiometryCode(Str $command, Str $target = 'WL' ) is export {*}

multi ToStoichiometryCode ( Str $command where not has-semicolon($command), Str $target = 'WL' ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my $match = Chemistry::Stoichiometry::Grammar.parse($command.trim, actions => %targetToAction{$target} );
    die 'Cannot parse the given command.' unless $match;
    return $match.made;
}

multi ToStoichiometryCode ( Str $command where has-semicolon($command), Str $target = 'WL' ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @cmdLines = map { ToStoichiometryCode($_, $target) }, @commandLines;

    @cmdLines = grep { $_.^name eq 'Str' }, @cmdLines;

    return @cmdLines.join( %targetToSeparator{$target} ).trim;
}
