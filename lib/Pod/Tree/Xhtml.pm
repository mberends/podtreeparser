# Pod/Tree/Xhtml.pm  xhtml emitter for Perl 6 tree based Pod parser

use Pod::Tree::Parser;       # Perldoc grammar and Parser role

$*stylesheet = q[code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }];  # TODO: use heredoc

class Pod::Tree::Xhtml does Pod::Tree::Parser {
    method TOP($/) {
        my $matches = [~] map( { $_.ast }, @( $/<section> ) );
        make qq[<?xml version="1.0" ?>\n]
           ~ qq[<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">\n]
           ~ qq[<html xmlns="http://www.w3.org/1999/xhtml">\n]
           ~ qq[<head><title>$!title</title>\n]
           ~ qq[<style type="text/css">\n$*stylesheet\n]
           ~ qq[</style>\n</head>\n<body>\n] ~ $matches
           ~ qq[</body>\n</html>];
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
		make "<!--ambient $ambient -->\n";
    }
    method pod6($/) {
        my Str $p6 = ~ $/<content>.ast;
        make "$p6";
    }
    method pod5($/) {
        my Str $p5 = ~ $/<content>.ast;
        make "blk beg pod DELIMITED version=>5\n$p5"
           ~ "blk end pod DELIMITED\n";
    }
    method content($/) {
        my Str $content = ~ $/;
        make "\n    <p>$content</p>\n";
    }
}

=begin pod

=head1 NAME
Pod::Tree::Xhtml - xhtml emitter for Perl 6 tree based Pod parser

=head1 SYNOPSIS
=begin code
# in shell
perl6 -e'use Pod::Tree::Xhtml; \
Pod::Tree::Xhtml.parse("=begin pod\nHello, pod!\n=end pod").say;'
=end code

=end pod
