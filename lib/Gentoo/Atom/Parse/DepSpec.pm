use strict;
use warnings;
package Gentoo::Atom::Parse::DepSpec;
# FILENAME: DepSpec.pm
# CREATED: 22/10/11 18:05:38 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Parse Gentoo Atom Dependency Specifications

use Moose;

=head1 DESCRIPTION

Gentoo has 2 types of Atoms it tends to use.

=over 4 

=item a. Canonical 

e.g:

  dev-lang/perl-5.10.1
  dev-lang/perl-5.10.1:0
  dev-lang/perl-5.10.1:0::gentoo

These tend to be "Informational", and intended as a way to convey information to a user.

These are also *not* usable as a package dependency specification.

  dev-lang/perl

Is not canonical either, as it can infer many different installable targets, and lacks version information.

=item b. Dependency Specifications

e.g:

  dev-lang/perl
  =dev-lang/perl-5.10.1
  =dev-lang/perl-5.10*
  ~dev-lang/perl-5.10.1
  >=dev-lang/perl-5.10.1
  <=dev-lang/perl-5.10.1
  !dev-lang/perl-5.10.1
  !!dev-lang/perl-5.10.1
  dev-lang/perl:0
  dev-lang/perl[ithreads]

Which are intended as internal mechanisims used by code to resolve compatible packages ( and sometimes used on the command line to be more specific as to what you want ).

=back


=cut


no Moose;
__PACKAGE__->meta->make_immutable;
1;


