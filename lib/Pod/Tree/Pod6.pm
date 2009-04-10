# Pod/Tree/Pod6.pm  diagnotic emitter for Perl 6 tree based Pod parser

use Pod::Tree::Parser;       # Perldoc grammar and Parser role

class Pod::Tree::Pod6 does Pod::Tree::Parser {
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
        make "=pod\n$p6=cut";
    }
    method pod5($/) {
        my Str $p5 = ~ $/<content>.ast;
        make "=begin pod\n$p5=end pod";
    }
    method content($/) {
        my Str $content = ~ $/;
        make "$content";
    }
}

=begin pod

=head1 NAME
Pod::Tree::Pod6 - Perl 6 Pod emitter for Perl 6 tree based Pod parser

=head1 SYNOPSIS
=begin code
# in shell
perl6 -e'use Pod::Tree::Pod6; \
Pod::Tree::Pod6.parse("=begin pod\nHello, pod!\n=end pod").say;'
=end code

=end pod
