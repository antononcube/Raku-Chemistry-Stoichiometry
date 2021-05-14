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
sub atomic-number($spec) is export {
    chemical-element-data($spec):atomic-number
}

#-----------------------------------------------------------
sub atomic-weight($spec) is export {
    chemical-element-data($spec):atomic-weight
}

#-----------------------------------------------------------
sub balance-chemical-equation(Str:D $spec ) is export {
    Chemistry::Stoichiometry::Grammar.parse($spec, actions => Chemistry::Stoichiometry::Actions::EquationBalance).made;
}

#-----------------------------------------------------------
sub chemical-symbol($spec) is export {
    chemical-element-data($spec):symbol
}

#-----------------------------------------------------------
sub chemical-element($spec) is export {
    chemical-element($spec):standard-name
}

#-----------------------------------------------------------
sub chemical-element-data($spec,
                          Bool :$symbol, Bool :$abbr,
                          Bool :$name, Bool :$standard-name,
                          Bool :$weight, Bool :$atomic-weight,
                          Bool :$number, Bool :$atomic-number) is export {

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
sub molecular-mass(Str:D $spec ) is export {
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
