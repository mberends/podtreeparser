# Pod/Tree/Test.pm  diagnotic emitter for Perl 6 tree based Pod parser

# Before testing any other emitters, this diagnostic emitter ensures
# that the Perldoc grammar in Pod::Tree::Parser can parse every test
# document.

use Pod::Tree::Parser;       # Perldoc grammar and Parser role

class Pod::Tree::Test does Pod::Tree::Parser {
    method TOP($/) {
        my $matches = [~] map( { $_.ast }, @( $/<section> ) );
        make "doc beg $!title\n" ~ $matches ~ "doc end";
    }
    method section($/) {
        my Str $section = ~ $0;
        if    defined($/<ambient>) { make ~ $/<ambient>.ast; }
        elsif defined($/<pod6>)    { make ~ $/<pod6>.ast; }
        elsif defined($/<pod5>)    { make ~ $/<pod5>.ast; }
    }
    method ambient($/) {
#       my Str $ambient = ~ $0;
#       chomp $ambient;
#       make "ambient $ambient\n";
        make [~] map( { "ambient $_\n" }, $/.comb(/\N+/) );
    }
    method pod6($/) {
        if    defined($/<p6delim>) { make ~ $/<p6delim>.ast; }
        elsif defined($/<p6para>)  { make ~ $/<p6para>.ast; }
        elsif defined($/<p6abbr>)  { make ~ $/<p6abbr>.ast; }
    }
    method p6delim($/) {
        my Str $p6 = ~ $/<content>.ast;
        make "blk beg pod DELIMITED version=>6\n$p6"
           ~ "blk end pod DELIMITED\n";
    }
    method p6para($/) {
#       warn "P6PARA in";
        my Str $p6para = ~ $/<content>.ast;
        make "blk beg pod PARAGRAPH version=>6\n$p6para"
           ~ "blk end pod PARAGRAPH\n";
#       warn "P6PARA ok";
    }
    method pod5($/) {
        my Str $p5 = ~ $/<content>.ast;
        make "blk beg pod DELIMITED version=>5\n$p5"
           ~ "blk end pod DELIMITED\n";
    }
    method content($/) {
        my $content = [~] map( { "content $_\n" }, $/.comb(/\N+/) );
        make "blk beg para PARAGRAPH\n{$content}blk end para PARAGRAPH\n";
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

=head1 SEE ALSO
L<doc:Pod::Tree::Parser>

=end pod
