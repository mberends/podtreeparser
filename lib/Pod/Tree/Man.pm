use Pod::Tree::Pod6; # the Pod grammar

class Pod::Tree::Man {
    has @!output;
    method TOP($/)       { make @!output.join("\n"); }
    method pod6block($/) { push @!output, "block"; }
    method begin($/)     { push @!output, "begin"; }
    method body($/)      { push @!output, "body"; }
    method end($/)       { push @!output, "end"; }
    method translate( Str $doc ) {
        return ~ Pod::Tree::Pod6.parse(
            $doc, :action( Pod::Tree::Man.new )
        )
    }
}

=begin pod

=head1 NAME
Pod::Tree::Man - convert Pod to man page

=end pod
