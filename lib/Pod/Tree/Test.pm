# Pod/Tree/Test.pm  diagnotic emitter for Perl 6 tree based Pod parser

use Pod::Tree::Pod6;       # the Perl 6 Pod grammar

class Pod::Tree::Test {
    method parse( Str $doc ) {
        Pod::Tree::Pod6.parse( $doc, :action( self.new ) ).ast;
    }
    method parsefile( Str $name ) {
        Pod::Tree::Pod6.parsefile( $name, :action( self.new ) ).ast;
    }
    method TOP($/) {
        my @matches = gather for @( $/<section> ) -> $m {take $m.ast;}
        make "doc beg test\n" ~ @matches ~ "\ndoc end";
    }
    method section($/) {
        my Str $section = ~ $0;
        if defined($/<ambient>) {
            my $ambient = $/<ambient>.ast;
            make "SECAM[$ambient]";
            warn "secam[$ambient]";
        }
        elsif defined($/<pod6>) {
            my $p6 = $/<pod6>.ast;
            make "$p6";
#           warn "secp6[$p6]";
        }
    }
    method ambient($/) {
        my Str $ambient = ~ $0;
		make "ambient $ambient\n";
    }
    method pod6($/) {
        my Str $p6 = ~ $/<content>.ast;
        make "blk beg pod DELIMITED version=>6\n$p6\n"
           ~ "blk end pod DELIMITED";
#       warn "pod6[$p6]";
    }
    method content($/) {
        my Str $content = ~ $/;
        make "blk beg para PARAGRAPH\ncontent $content\n"
           ~ "blk end para PARAGRAPH";
#       warn "content[$content]";
    }
}

# http://irclog.perlgeek.de/perl6/2009-03-23#i_1008989
# moritz_ but you can always make [@( $/.ast ), $new_value]
# moritz_ that's basically the same as $/.ast.push($new_value), but it should atually work :-)
# moritz_ .ast is the same as $(), ie the payload that you put onto the Match object by calling make
# pugs/docs/Perl6/Spec/S05-regex.pod:2451 describes 'make'

=begin pod

=head1 NAME
Pod::Tree::Test - diagnotic trace emitter for Perl 6 tree based Pod parser

=head1 SYNOPSIS
=begin code
# in shell
perl6 -e'use Pod::Tree::Test; \
Pod::Tree::Test.parse("=begin pod\nHello, pod!\n=end pod").say;'
=end code

=end pod
