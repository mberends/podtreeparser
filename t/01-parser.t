#!/usr/local/bin/perl6
use Test::Differences;
use Pod::Tree::Test;
#use Pod::Tree::Pod6;

plan 9;

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

$received = Pod::Tree::Test.parse( slurp('t/p01-ambient.pod') );
$expected = "doc beg test\ndoc end";
eq_or_diff( $received, $expected, 'p01-ambient.pod' );

$received = Pod::Tree::Test.parse( slurp('t/p02-para.pod') );
$expected = "doc beg test\ndoc end";
eq_or_diff( $received, $expected, 'p02-para.pod' );

$received = Pod::Tree::Test.parse( slurp('t/p03-head.pod') );
$expected = "doc beg test\ndoc end";
eq_or_diff( $received, $expected, 'p03-head.pod' );

$received = Pod::Tree::Test.parse( slurp('t/p04-code.pod') );
$expected = "doc beg test\ndoc end";
eq_or_diff( $received, $expected, 'p04-code.pod' );

$received = Pod::Tree::Test.parse( slurp('t/p05-pod5.pod') );
$expected = "doc beg test\ndoc end";
eq_or_diff( $received, $expected, 'p05-pod5.pod' );

$received = Pod::Tree::Test.parse( slurp('t/p07-basis.pod') );
$expected = "doc beg test\ndoc end";
eq_or_diff( $received, $expected, 'p07-basis.pod' );

$received = Pod::Tree::Test.parse( slurp('t/p08-code.pod') );
$expected = "doc beg test\ndoc end";
eq_or_diff( $received, $expected, 'p08-code.pod' );

$received = Pod::Tree::Test.parse( slurp('t/p13-link.pod') );
$expected = "doc beg test\ndoc end";
eq_or_diff( $received, $expected, 'p13-link.pod' );

#$received = Pod::Tree::Test.parse( slurp('../pugs/docs/Perl6/Spec/S26-documentation.pod') );
#$expected = "doc beg test\ndoc end";
#eq_or_diff( $received, $expected, 'S26-documentation.pod' );

