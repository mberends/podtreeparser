use Pod::Tree::Pod6;       # the Perl 6 Pod grammar

class Directive { has Str $!typename; }

class Perldoc::Block::Ambient { }
class Perldoc::Block { has $.version; }

class Pod::Tree::Test_bak {
    has @!output;

    method TOP($/) {
#       warn "TOP in " ~ $/.WHAT;
        my @keys = @( $/<anyline> );
        # warn "{+@keys} keys: {@keys.map({chomp $_})}";
#       make gather for @( $/ ) -> $m {
#           if $m<directive> { warn "DIRECTIVE" }
#           elsif $m<content> { warn "CONTENT" }
#           take $m.ast;
#       }
        make "doc beg test\n" ~
             [~] gather for @( $/ ) -> $m {
                 if defined $m.ast { take $m.ast };
             } ~ "\n" ~
             "doc end";
        warn "TOP ok " ~ $/.WHAT;
    }
    method ambient($/) {
        warn "ambient in " ~ $/;
#       make [@( $/.ast ), Perldoc::Block::Ambient.new ];
        make "ambient";
        warn "ambient ok " ~ $/.ast;
    }
    method pod6($/) {
#       warn "pod6 in";
        make "blk beg pod DELIMITED version=>6\n{1}\nblk end pod DELIMITED";
#       warn "pod6 ok";
    }
    method content($/) {
        warn "content in";
        my $matched = ~ $/;
        my $payload = [@( $/.ast ), "content" ];
        make $payload;
#       warn "matched '$matched'";
    }
    method pod5($/) {
#       warn "p5block in";
        my $payload = [@( $/.ast )];
        make $payload;
    }
    method directive($/) {
        warn "directive in";
        my $payload = [@( $/.ast )];
        make $payload;
    }

    method parse( Str $doc ) {
        return ~ Pod::Tree::Pod6.parse(
            $doc, :action( Pod::Tree::Test.new )
        )
    }
}

class Pod::Tree::Test {
    method parse( Str $doc ) {
        ~ Pod::Tree::Pod6.parse( $doc, :action( self.new ) );
    }
    method TOP($/) {
        my @matches = gather for @( $/<section> ) -> $m {take $m.ast;}
		make "doc beg test\n" ~ @matches ~ "\ndoc end";
    }
    method section($/) {
        my Str $section = ~ $0;
        if    defined($/<ambient>) { make "SA[{$/<ambient>}]" }
        elsif defined($/<pod6>)    { make "{$/<pod6>}" }
    }
    method ambient($/) {
        my Str $ambient = ~ $0;
		make "ambient $ambient\n";
    }
    method pod6($/) {
        my Str $pod6 = ~ $0;
		make "blk beg pod DELIMITED\n$pod6\nblk end pod DELIMITED";
    }
}

# http://irclog.perlgeek.de/perl6/2009-03-23#i_1008989
# moritz_ but you can always make [@( $/.ast ), $new_value]
# moritz_ that's basically the same as $/.ast.push($new_value), but it should atually work :-)
# moritz_ .ast is the same as $(), ie the payload that you put onto the Match object by calling make
# pugs/docs/Perl6/Spec/S05-regex.pod:2451 describes 'make'

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
