
use Text::CSV;

class Chemistry::Stoichiometry::ResourceAccess {
    ##========================================================
    ## Data
    ##========================================================
    my @elementData;
    my Num %standardNameToAtomicWeight{Str};
    my Str %abbrToStandardName{Str};
    my Str %standardNameToAbbr{Str};
    my Int %standardNameToAtomicNumber{Str};
    my Str %atomicNumberToStandardName{Int};
    my Hash %langNames{Str};

    ##========================================================
    ## BUILD
    ##========================================================
    # We create a lexical variable in the class block that holds our single instance.
    my Chemistry::Stoichiometry::ResourceAccess $instance = Nil;

    my Int $numberOfInstances = 0;

    method getNumberOfInstances() { $numberOfInstances }

    my Int $numberOfMakeCalls = 0;

    method getNumberOfMakeCalls() { $numberOfMakeCalls }

    method new {!!!}

    submethod instance {

        $instance = Chemistry::Stoichiometry::ResourceAccess.bless unless $instance;

        if $numberOfInstances == 0 {
            $instance.make()
        }

        $numberOfInstances += 1;

        $instance
    }

    method make() {
        $numberOfMakeCalls += 1;
        #say "Number of calls to .make $numberOfMakeCalls";

        #-----------------------------------------------------------
        my $fileName = %?RESOURCES{'ElementData.csv'};

        say $fileName;

        my $csv = Text::CSV.new;
        @elementData = $csv.csv(in => $fileName.Str, headers => 'auto');

        # Verify expectations
        my @expectedColumnNames = <StandardName Name Abbreviation AtomicNumber AtomicWeight Block Group Period Series>;

        if (@elementData[0].keys (&) @expectedColumnNames).elems < @expectedColumnNames.elems {
            die "The CSV file $fileName does not have the expected column names: {@expectedColumnNames.join(', ')}.";
        }

        # Create dictionaries
        # Maybe it is better to have a dictionary of dictionaries.
        %standardNameToAtomicWeight = @elementData.map( { $_<StandardName>     => $_<AtomicWeight>.Num } );
        %standardNameToAbbr =         @elementData.map( { $_<StandardName>     => $_<Abbreviation> } );
        %abbrToStandardName =         @elementData.map( { $_<Abbreviation>     => $_<StandardName> } );
        %standardNameToAtomicNumber = @elementData.map( { $_<StandardName>     => $_<AtomicNumber>.Int } );
        %atomicNumberToStandardName = @elementData.map( { $_<AtomicNumber>.Int => $_<StandardName> } );

        #-----------------------------------------------------------
        @expectedColumnNames = <Index Name Abbreviation StandardName>;

        # The language list has to be derived automatically instead specified manually.
        for <Bulgarian Japanese Russian> -> $fn {
            my $fileName = %?RESOURCES{'ElementNames_' ~ $fn ~ '.csv'};
            my Str @nameIDPairs = $fileName.lines;

            my $csv = Text::CSV.new;
            my @elementDataLocalized = $csv.csv(in => $fileName.Str, headers => 'auto');

            if (@elementDataLocalized[0].keys (&) @expectedColumnNames).elems < @expectedColumnNames.elems {
                die "The $fn CSV file $fileName does not have the expected column names: {@expectedColumnNames.join(', ')}.";
            }

            my %nameRules = @elementDataLocalized.map({ $_<Name>.lc => $_<StandardName> });
            %langNames = %langNames.push( $fn => %nameRules );
        }

        # For completeness, add English
        %langNames.push( "English" => Hash(@elementData.map({ $_<Name>.lc  => $_<StandardName> })) );

        #-----------------------------------------------------------
        self
    }

    ##========================================================
    ## Access
    ##========================================================
    # If a dictionary of dictionaries is used these can be refactored.
    multi method get-standard-name(Str:D $spec --> Str) {
        if %abbrToStandardName{$spec}:exists {
            %abbrToStandardName{$spec}
        } else {
            my $res = Nil;
            for %langNames.keys -> $l {
                $res = %langNames{$l}{$spec.lc};
                last if $res.defined;
            }
            die "Unknown chemical element name or abbreviation: $spec" unless $res.defined;
            $res
        };
    }

    multi method get-standard-name(Int:D $spec --> Str) {
        die "Unknown atomic number: $spec" unless %atomicNumberToStandardName{$spec}:exists;
        %atomicNumberToStandardName{$spec};
    }

    multi method get-atomic-weight(Str:D $spec --> Num) {
        if %standardNameToAtomicWeight{$spec}:exists { %standardNameToAtomicWeight{$spec} }
        elsif %abbrToStandardName{$spec}:exists { %standardNameToAtomicWeight{%abbrToStandardName{$spec}}}
        else { die "Unknown chemical element standard name or abbreviation: $spec." };
    }

    multi method get-atomic-weight(Int:D $spec --> Num) {
        die "Unknown atomic number: $spec" unless %atomicNumberToStandardName{$spec}:exists;
        %standardNameToAtomicWeight{%atomicNumberToStandardName{$spec}};
    }
}
