# Pod/Tree/Text.pm  plain text emitter for Perl 6 tree based Pod parser

use Pod::Tree::Pod6;       # the Perl 6 Pod grammar

class Pod::Tree::Text {
    has Str $!title = 'test';
    multi method parse( Str $doc ) {
        Pod::Tree::Pod6.parse( $doc, :action( self.new ) ).ast;
    }
    multi method parse( Str $doc, Str $doctitle ) {
        $!title = $doctitle;
        Pod::Tree::Pod6.parse( $doc, :action( self.new ) ).ast;
    }
    multi method parsefile( Str $name ) {
        Pod::Tree::Pod6.parsefile( $name, :action(self.new) ).ast;
    }
    multi method parsefile( Str $name, Str $doctitle ) {
        $!title = $doctitle;
        Pod::Tree::Pod6.parsefile( $name, :action(self.new) ).ast;
    }
    method TOP($/) {
        my $matches = [~] map( { $_.ast }, @( $/<section> ) );
        make $matches;
    }
    method section($/) {
        my Str $section = ~ $0;
        if    defined($/<ambient>) { make ~ $/<ambient>.ast; }
        elsif defined($/<pod6>)    { make ~ $/<pod6>.ast; }
        elsif defined($/<pod5>)    { make ~ $/<pod5>.ast; }
    }
    method ambient($/) {
        my Str $ambient = ~ $0;
        chomp $ambient;
		make "ambient $ambient\n";
    }
    method pod6($/) {
        my Str $p6 = ~ $/<content>.ast;
        make $p6;
    }
    method pod5($/) {
        my Str $p5 = ~ $/<content>.ast;
        make "blk beg pod DELIMITED version=>5\n$p5"
           ~ "blk end pod DELIMITED\n";
    }
    method content($/) {
        my Str $content = ~ $/;
        make "    $content";
    }
}

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
