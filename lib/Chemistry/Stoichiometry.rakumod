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
use Chemistry::Stoichiometry::Actions::MolecularMass;
use Chemistry::Stoichiometry::Actions::WL::System;

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
sub molecular-mass(Str $spec ) is export {
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
