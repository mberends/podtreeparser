# Warning: Under Construction: nothing works or even makes sense!

grammar Pod::Tree::Pod6 {
    regex TOP { ^ <section> * $ {*} }
    regex section { [ <ambient> | <pod6> ] {*} }
    regex ambient { ^^ ( <-[=]> .*? ) $$ \n? <?before [ ^^ '=' | $ ] > {*} }
    regex pod6 { ^^   '=begin pod' ( .*? ) '=end pod' $$ \n? {*} }
#   regex pod6 { ^^ ( '=begin pod' ( <content> ) '=end pod' ) $$ \n? {*} }
    regex pod5 { ^^ ( '=pod' .*? '=cut' ) $$ \n? {*} }
    regex content { .*? \n? <?before [ ^^ '=' | $ ] > {*} }
}

#class Pod::Tree::Pod6::ambient { } # suggested in S26

=begin pod

=head1 NAME
Pod::Tree::Pod6 - grammar for Perl 6 tree based Pod processors

=head1 SYNOPSIS
=begin code
use Pod::Tree::Xhtml; Pod::Tree::Xhtml.parse(slurp('example.pod')).say;
=end code

=head1 DESCRIPTION
Under construction. Nothing works yet. No finish date promised either.

This is a tree based parser for Perl 6 Pod as specified in
L<S26|http://perlcabal.org/syn/S26.html>. The draft status of S26 is
no problem, assuming maintenance can track revisions.
After all, Pod must keep the spirit of Pod to merit the name.

Learning lessons from the stream based L<Pod::Parser|http://github.com/eric256/perl6-examples/blob/master/lib/Pod/Parser.pm>,
this implementation puts all the code into a grammar and an action class.
The grammar is designed for possible inclusion in STD.pm.
Every implemented method must be fully tested with both valid and
invalid cases.

=head1 RATIONALE (please notify author about factual errors)
Tree based parsers generally use more memory than stream based ones, on
Pod as well as XML, because all the content must be retained, not just
the data actively being processed. It's the Unix pipeline filters versus
the load-save model. The current (March 2009) Parrot and Rakudo
implementations, however, lack heap memory garbage collection, with dire
consequences that hamper production use.

The accepted priority for Parrot and Rakudo developers is functionality
first, optimization second. Fair enough, but nearly every looping, long
running process leaks memory. The operating system resorts to swapping
hectically in a hopeless effort to provide more, but Parrot doesn't
recycle and keeps calling malloc(). After almost hanging the computer
for a long time the kernel usually kills the Parrot.

Running L<Pod::Server|http://github.com/eric256/perl6-examples/blob/master/lib/Pod/Server.pm>
and L<Pod::Parser|http://github.com/eric256/perl6-examples/blob/master/lib/Pod/Parser.pm>
causes huge memory and CPU loads. Some approximate Pod::Server responses:

 Document                                   size  time   RAM
 rakudo/docs/compiler_overview.pod            9k   54s  224M
 rakudo/docs/glossary.pod                     4k   19s  132M
 rakudo/docs/guide_to_setting.pod             3k   15s  114M
 rakudo/docs/release_guide.pod                1k    5s   94M
 pugs/docs/Perl6/Spec/S01-overview.pod        5k   28s  158M
 pugs/docs/Perl6/Spec/S02-bits.pod          151k  600s 1583M (died)
 pugs/docs/Perl6/Spec/S03-operators.pod     150k
 pugs/docs/Perl6/Spec/S04-control.pod        58k  340s 1048M (died)
 pugs/docs/Perl6/Spec/S05-regex.pod         133k
 pugs/docs/Perl6/Spec/S06-routine.pod       113k
 pugs/docs/Perl6/Spec/S07-iterators.pod       7k   35s  174M
 pugs/docs/Perl6/Spec/S09-data.pod           46k  255s  820M (died)
 pugs/docs/Perl6/Spec/S10-packages.pod        8k   49s  204M
 pugs/docs/Perl6/Spec/S10-modules.pod        22k  137s  433M

Results on a dual core amd64 4200+, 2GB memory, running Linux. Only one
CPU core runs each process :(

Seeing memory use up to 15000 times document size is worrying.
The developer guidelines that apply to Java and .NET probably apply to
Rakudo as well - keep the application code small and shift as much of
the heavy processing burden as possible to the standard libraries of the
language.

In L<code review of Pod::Parser|http://use.perl.org/~masak/journal/38644>
Carl Mäsak++ wrote "all the grunt work, is made by the Pod6 grammar".
That observation and the excellent code Matthew Walton has written in
L<Form.pm|http://github.com/mattw/form/tree/master> inspired this tree
parser. Through actions, the grammar will not only pattern match the Pod
syntax but also dispatch to the handler, in most cases an emitter.
If it works, comparing stream versus tree parsing performance will be
interesting.
In the spirit of "prepare to throw one away", let the best solution win.

Stream processing redefines many small strings in frequent loops,
requesting many heap allocations.
Tree processing handles an entire document in a single call with
grammar, regexes and action classes. It might be faster and more compact
on the current Parrot and Rakudo.

Another reason for this effort is to have another trial implementation
to discover potential pitfalls before settling the S26 spec.

=head1 TESTING
A rigorous Test Driven Development policy must be enforced. Adding each
functional unit begins by adding unit tests that accurately reference
the specification. Before the arrival of suitable automated tools,
coverage of the code and the specification must be assessed manually.

=head2 Test Coverage

=head3 Specification Implemented

=head3 Specification To Do

=head3 Code Tested

=head3 Code Untested
(covering these is always top priority)

=head1 AUTHOR
Martin Berends (mberends on CPAN github #perl6 and @autoexec.demon.nl).

=head1 SEE ALSO
L<S26|http://perlcabal.org/syn/S26.html>
L<http://www.nntp.perl.org/group/perl.perl6.language/2007/07/msg27890.html>
L<http://www.nntp.perl.org/group/perl.perl6.language/2007/07/msg27894.html>

=end pod
