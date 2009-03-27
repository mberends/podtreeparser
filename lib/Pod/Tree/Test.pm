use Pod::Tree::Pod6;       # the Perl 6 Pod grammar

class Pod::Tree::Test {
    has @!output;

    method TOP($/) {
        warn "starting TOP";
        my @keys = @( $/<anyline> );
        warn "KEYS: {@keys}";
        make gather for @( $/<anyline> ) -> $m { take $m.ast; }
        warn "leaving TOP";
    }
    method directive($/) {
        warn "starting directive";
        my $payload = [@( $/.ast )];
        make $payload;
        warn "leaving directive";
    }
    method beginpod($/) {
        warn "starting beginpod";
        my $payload = [@( $/<typename>.ast )];
        make $payload;
    }
    method endpod($/) {
        warn "starting endpod";
        my $payload = [@( $/.ast )];
        make $payload;
    }
    method content($/) {
        warn "starting content";
        my $matched = ~ $/;
        my $payload = [@( $/.ast )];
        make $payload;
#       warn "matched '$matched'";
    }

    method parse( Str $doc ) {
        return ~ Pod::Tree::Pod6.parse(
            $doc, :action( Pod::Tree::Test.new )
        )
    }
}

# moritz_ but you can always make [@( $/.ast ), $new_value]
# moritz_ that's basically the same as $/.ast.push($new_value), but it should atually work :-)
# moritz_ .ast is the same as $(), ie the payload that you put onto the Match object by calling make

=begin pod

=head1 NAME
Pod::Tree::Test - class to trace parsing of Pod

=head1 SYNOPSIS
=begin code
# in shell
perl6 -e'use Pod::Tree::Test; \
say Pod::Tree::Test.new.parse("=begin pod\nHello, pod!\n=end pod");'
=end code

=end pod
