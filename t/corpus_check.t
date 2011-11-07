use 5.010001;
use strict;
use warnings;

use Test::More;

plan tests => 33954;
# FILENAME: corpus_check.t
# CREATED: 07/11/11 16:42:56 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: A check for Corpus consistency

use FindBin;
use lib "$FindBin::Bin/tlib/";
use lib "$FindBin::Bin/../lib/";

use Path::Class::Dir;
use Data::Dump qw( pp );
use miniparser;


my $t_dir = Path::Class::Dir->new( $FindBin::Bin );
my $root = $t_dir->parent;
my $corpus = $root->subdir('corpus');

my $input = $corpus->file('cpv-list.txt')->openr;
my $expected = $corpus->file('cpv-list-qatom.txt')->openr;

diag "This will take a while to verify all 33954 versions, patience =)";
while (1) {
  last if $input->eof;
  my $source_atom = $input->getline();
  my $expected_tokens = $expected->getline();
  chomp for $source_atom, $expected_tokens;
  my ( @expected_tokens ) = split / / , $expected_tokens;

  my ( @extra ) = splice @expected_tokens, 2;
  push @expected_tokens, join q{-}, @extra;
  my ( $parse ) = miniparser::parse_cpv( $source_atom );
  my %CPV = %{$parse->{CPV}};
  my ( @result ) = @CPV{qw( CategoryName PackageName Version )};
  is_deeply( \@expected_tokens, \@result , " $source_atom " );
}

done_testing;


