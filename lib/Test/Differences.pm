# Test::Differences for Perl 6 (Rakudo)

use Test;

multi sub eq_or_diff($received, $expected, Str $desc) is export()
{
    is( $received, $expected, $desc ); # from module Test

    if $received ne $expected {
        my @expected = $expected.split("\n");
        my @received = $received.split("\n");
        say "# failed $desc";
        say "#### expected: " ~ "-" x 20;
        for 0 .. @expected.elems-1 -> $i {
            say "#$i## {@expected[$i]}";
        }
        say "#### received: " ~ "-" x 20;
        for 0 .. @received.elems-1 -> $i {
            my $status =
                ( $i < @expected.elems and @received[$i] eq @expected[$i] )
                ?? "==" !! "!=";
            say "#$i$status {@received[$i]}";
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
