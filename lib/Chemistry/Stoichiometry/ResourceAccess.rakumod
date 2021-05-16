
use Text::CSV;

class Chemistry::Stoichiometry::ResourceAccess {
    ##========================================================
    ## Data
    ##========================================================
    my @elementData;
    my %elementData;
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

        my $csv = Text::CSV.new;
        @elementData = $csv.csv(in => $fileName.Str, headers => 'auto');

        # Verify expectations
        my @expectedColumnNames = <StandardName Name Abbreviation AtomicNumber AtomicWeight Block Group Period Series>;

        if (@elementData[0].keys (&) @expectedColumnNames).elems < @expectedColumnNames.elems {
            die "The CSV file $fileName does not have the expected column names: {@expectedColumnNames.join(', ')}.";
        }

        # Convert the numerical fields into numbers.
        @elementData = do for @elementData -> %row {
            my %res = %row, %( AtomicNumber => %row<AtomicNumber>.Int, AtomicWeight => %row<AtomicWeight>.Num );
            %res
        }

        # Make element data dictionary
        %elementData = @elementData.map({ $_<StandardName>.lc => $_ });

        # Create dictionaries
        # Maybe it is better to have a dictionary of dictionaries.
        %standardNameToAtomicWeight = @elementData.map( { $_<StandardName> => $_<AtomicWeight> } );
        %standardNameToAbbr =         @elementData.map( { $_<StandardName> => $_<Abbreviation> } );
        %abbrToStandardName =         @elementData.map( { $_<Abbreviation> => $_<StandardName> } );
        %standardNameToAtomicNumber = @elementData.map( { $_<StandardName> => $_<AtomicNumber> } );
        %atomicNumberToStandardName = @elementData.map( { $_<AtomicNumber> => $_<StandardName> } );

        #-----------------------------------------------------------
        @expectedColumnNames = <Index Name Abbreviation StandardName>;

        # The language list has to be derived automatically instead specified manually.
        for <Bulgarian Japanese Persian Russian Spanish> -> $fn {
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

        # For completeness, add English.
        %langNames.push( "English" => Hash(@elementData.map({ $_<Name>.lc  => $_<StandardName> })) );

        #-----------------------------------------------------------
        self
    }

    ##========================================================
    ## Access
    ##========================================================
    multi method get-element-data() {
        %elementData
    }

    multi method get-element-data($spec) {

        my $stdName = self.get-standard-name($spec);

        if not $stdName.defined {
            warn "The specification $spec is not a known chemical element.";
            return Nil
        }

        %elementData{$stdName.lc}
    }

    method get-number-of-elements() {
        @elementData.elems
    }

    # If a dictionary of dictionaries is used the functions below can be refactored.
    multi method get-standard-name(Str:D $spec) {
        if %abbrToStandardName{$spec}:exists {
            %abbrToStandardName{$spec}
        } elsif %standardNameToAtomicNumber{$spec.lc}:exists {
            $spec.lc.tc
        } else {
            my $res = Nil;
            for %langNames.keys -> $l {
                $res = %langNames{$l}{$spec.lc};
                last if $res.defined;
            }
            warn "Unknown chemical element name or abbreviation: $spec" unless $res.defined;
            $res
        }
    }

    multi method get-standard-name(Int:D $spec --> Str) {
        if %atomicNumberToStandardName{$spec}:exists {
            %atomicNumberToStandardName{$spec}
        } else {
            warn "Unknown atomic number: $spec";
            Nil
        }
    }

    multi method get-standard-name($spec, Str:D $language --> Str) {
        my Str $stdName = self.get-standard-name($spec);

        warn "Unknown language $language. Known languages are {%langNames.keys}" unless $language.lc.tc (elem) %langNames.keys;

        %(%langNames{$language.lc.tc}.invert){$stdName}.lc.tc
    }

    multi method get-atomic-weight(Str:D $spec --> Num) {
        if %standardNameToAtomicWeight{$spec}:exists {
            %standardNameToAtomicWeight{$spec}
        } else {
            my $stdName = self.get-standard-name($spec);
            with $stdName {
                %standardNameToAtomicWeight{$stdName}
            } else {
                Nil
            }
        }
    }

    multi method get-atomic-weight(Int:D $spec --> Num) {
        if %atomicNumberToStandardName{$spec}:exists {
            %standardNameToAtomicWeight{%atomicNumberToStandardName{$spec}}
        } else {
            warn "Unknown atomic number: $spec.";
            Nil
        }
    }

    method get-atomic-number(Str:D $spec --> Int) {
        if %standardNameToAtomicNumber{$spec}:exists {
            %standardNameToAtomicNumber{$spec}
        } else {
            my $stdName = self.get-standard-name($spec);
            with $stdName {
                %standardNameToAtomicNumber{$stdName}
            } else {
                Nil
            }
        }
    }
}
