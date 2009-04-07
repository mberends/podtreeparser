# Pod/Tree/Man.pm  man page emitter for Perl 6 tree based Pod parser

use Pod::Tree::Pod6;       # the Perl 6 Pod grammar

class Pod::Tree::Man {
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
    sub docdate( Num $seconds ) {
        # Bogus year-month-day calculation.
        # Needs an accurate localtime() function to replace this kludge.
        my $day   = floor( $seconds / 3600 / 24 );
        my $year  = floor( $day / 365.24 ); $day -= floor( $year * 365.24 );
        my $month = floor( $day / 30.5 );   $day -= floor( $month * 30.5 );
        return sprintf( "%4d-%02d-%02d", $year+1970, $month+1, $day+1 );
    }
    method TOP($/) {
        my $docdate = docdate( time() );
        my $matches = [~] map( { $_.ast }, @( $/<section> ) );
        make qq[.TH $!title 6 "$docdate" "Perl 6" "Plain Old Documentation"\n]
           ~ qq[.nh\n.ad l\n$matches.\\" $!title end.];
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
        make ".PP\n$content\n";
    }
}

=begin pod

=head1 NAME
Pod::Tree::Man - man page emitter for Perl 6 tree based Pod parser

=head1 SYNOPSIS
=begin code
# in shell
perl6 -e'use Pod::Tree::Man; \
Pod::Tree::Man.parse("=begin pod\nHello, pod!\n=end pod").say;'
=end code

=end pod
