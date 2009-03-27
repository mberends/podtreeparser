# Test::Differences for Perl 6 (Rakudo)

use Test;

multi sub eq_or_diff($received, $expected, Str $desc) is export()
{
    is( $received, $expected, $desc ); # from module Test

    if $received ne $expected {
        say "# failed $desc";
        say "#### expected: " ~ "-" x 20;
        my @expected = $expected.split("\n");
        my $i = 0;
        say @expected.map({"#" ~ $i++ ~ "## $_"}).join("\n");
        say "#### received: " ~ "-" x 20;
        my @received = $received.split("\n");
        $i = 0;
        while $i < @received.elems {
            my $status = "!=";
            if $i < @expected.elems and @received[$i] eq @expected[$i] {
                $status = "==";
            }
            say "#$i$status {@received[$i]}";
            $i++;
        }
    }
}

=begin pod

=head1 NAME
Test::Differences - check test results and clearly contrast failures

=head1 TODO
Make a side by side comparison layout the way the Perl 5 version does.

=head1 SEE ALSO
The Perl 5 L<doc:Test::Differences> by Barrie Slaymaker.

=end pod
