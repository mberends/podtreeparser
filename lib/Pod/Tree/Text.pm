# Pod/Tree/Text.pm  plain text emitter for Perl 6 tree based Pod parser

use Pod::Tree::Parser;       # Perldoc grammar and Parser role

class Pod::Tree::Text does Pod::Tree::Parser {
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
        if    defined($/<p6delim>) { make ~ $/<p6delim>[0].ast; }
        elsif defined($/<p6para>)  { make ~ $/<p6para>[0].ast; }
        elsif defined($/<p6abbr>)  { make ~ $/<p6abbr>[0].ast; }
    }
    method p6delim($/) {
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
