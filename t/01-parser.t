#!/usr/local/bin/perl6
use Test::Differences;
use Pod::Tree::Test;
#use Pod::Tree::Pod6;

plan 1;

my ( Str $received, Str $expected );

$received = Pod::Tree::Test.parse( slurp('t/p01-plain.pod') );
$expected = "doc beg test
blk beg pod DELIMITED version=>6
blk beg para PARAGRAPH
content document 01 plain text
blk end para PARAGRAPH
blk end pod DELIMITED
doc end";
eq_or_diff( $received, $expected, 'p01-plain.pod simplest text' );

#my Str $pod = "=begin pod\nh\n=end pod";
#$expected = "begin\nbody\nbody\nbody\nbody\nbody\nbody\nbody\nbody\nend\nblock";
#$received = Pod::Tree::Pod6.parse( $pod, :action( Pod::Tree::Diagnostic.new ) );
#$received = Pod::Tree::Diagnostic.translate( $pod );
#eq_or_diff( $received, $expected, 'p01-plain.pod simplest text' );
