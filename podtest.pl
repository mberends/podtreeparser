use v6; BEGIN { @*INC.push( './lib' ); } # instead of using PERL6LIB
use Test;

grammar Pod::Tree::Pod6 {
    regex TOP { ^ <section> * $ {*} }
    regex section { [ <ambient> | <pod6> ] {*} }
    regex ambient { ^^ ( <-[=]> .*? ) $$ \n? <?before [ ^^ '=' | $ ] > {*} }
    regex pod6 { ^^ ( '=begin pod' .*? '=end pod' ) $$ \n? {*} }
    regex pod5 { ^^ ( '=pod' .*? '=cut' ) $$ \n? {*} }
}

class Pod::Tree::Test {
    method parse( Str $doc ) {
        Pod::Tree::Pod6.parse( $doc, :action( self.new ) ).ast;
    }
    method TOP($/) {
        my @matches = gather for @( $/<section> ) -> $m {
            my $topsect = $m.ast;
            take $topsect;
        }
        make @matches;
        my $matches = [~] @matches;
        make "doc beg\n$matches\ndoc end";
        warn "top[$matches]";
    }
    method section($/) {
        my Str $section = ~ $/.ast;
        if defined($/<ambient>) {
            my $ambient = $/<ambient>.ast;
            make "SECAM[$ambient]";
#           warn "secam[$ambient]";
        }
        elsif defined($/<pod6>) {
            my $pod6 = $/<pod6>.ast;
            make "SECP6[$pod6]";
#           warn "secp6[$pod6]";
        }
        # warn "section[$section]";
    }
    method ambient($/) {
        my Str $ambient = ~ $0;
        make "AM[$ambient]";
    }
    method pod6($/) {
        my Str $pod6 = ~ $0;
        make "P6[$pod6]";
#       warn "pod6[$pod6]";
    }
}

plan 1;

my $emitter = Pod::Tree::Test.new;
#ok($emitter, "Pod::Tree::Test constructs");

my $tree = Pod::Tree::Test.parse("b 1\nb 2\nb 3\n=begin pod\nwords\n=end pod\na 1\na 2\na 3");
#my $tree = Pod::Tree::Pod6.parse("b 1\nb 2\nb 3\n=begin pod\nwords\n=end pod\na 1\na 2\na 3", :action($emitter));
ok($tree, "parse simple pod");
warn "AST:" ~ $tree;
