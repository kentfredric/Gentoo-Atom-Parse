use 5.010000;
use strict;
use warnings;

use Test::More;

# FILENAME: grammar_packagenames.t
# CREATED: 22/10/11 18:16:55 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Test the regexp Grammar for Package Names

use FindBin;
use lib "$FindBin::Bin/tlib/";
use lib "$FindBin::Bin/../lib/";
use miniparser;

{
  my ($result) = miniparser::parse( ' perl gcc gtk+ Data-Dumper ', '<PackageName>' );
  my (@package_names) = grep { defined } map { $_->{PackageName} } @{ $result->[1]->{match} };
  is_deeply( [qw( perl gcc gtk+ Data-Dumper )], \@package_names, 'Package Name token validation' );
}
{
  my ($result) = miniparser::parse( ' 1 1.1 1.5 1.0.1 1.0.1a 1.0.1pr 1.0.1pre ', '<VersionNumber>' );
  my (@versions) = grep { defined } map { $_->{VersionNumber} } @{ $result->[1]->{match} };
  is_deeply( [qw( 1 1.1 1.5 1.0.1 1.0.1 1.0.1 1.0.1 )], \@versions, 'Version number token parsing' );
}
{
  my ($result) = miniparser::parse( '  1 1.1 1.5 1.0.1 1.0.1a 1.0.1pr 1.0.1pre 1.0.1_pr 1.0.1_pre 1.0.1_p ', '<Version>(\s|$)' );
  my (@versions) = grep { defined } map { $_->{Version} } @{ $result->[1]->{match} };
  is_deeply( [qw( 1 1.1 1.5 1.0.1 1.0.1a 1.0.1_pre 1.0.1_p )], \@versions, 'Version token parsing' );
}

subtest "Version strict conformance" => sub {
  my ( %X_fail ) = map { $_ => 1 } qw( 1.0.1_pr 1.0.1pr 1.0.1pre );

  for my $version (qw( 1 1.1 1.5 1.0.1 1.0.1a 1.0.1pr 1.0.1pre 1.0.1_pr 1.0.1_pre 1.0.1_p  )) {
    subtest "V = $version" => sub {
      my ($result) = miniparser::strict_check( [$version], 'Version' );
      is ( scalar keys %{$result},1 , "Expected only 1 key back($version)");
      my ($key) = keys %{$result};
      is ( $key, $version, "Key matches version being tested($version)" );
      my ($hash) = values %{$result};
      if ( not ref $hash eq 'HASH' ){ 
        if ( exists $X_fail{$version} ) { 
          pass("$version is correctly not a version");
          return;
        }
        fail("Not a hash ref");
        diag explain $result;
        return;
      }
      if ( exists $X_fail{$version} ) {
        fail("Expected $version to not be a version but parsed anyway");
      }
      ok( exists $hash->{Version}, 'Version was detected' );
      is( $hash->{Version} , $version, 'Detected version is identical' );
#      say Data::Dump::pp( miniparser::strict_check( [$version], 'Version' ) );
    }
  }
};

subtest "CPV Parsing" => sub { 
  my @items = (      
    [qw( dev-lang perl 5.10.1 ) ],
    [qw( dev-lang nqp  0.1.2  )],
  );
  for my $test ( @items ) {
    my $name = sprintf "%s/%s-%s", @{$test};
    subtest "CPV parse item:  $name" => sub { 
      my ( $result ) = miniparser::check_cpv( $test, );
      is( ref $result , 'ARRAY' , 'Result is an array') or return;
      ok( exists $result->[0] , 'Array has 0 key' ) or return;
      my $hash = $result->[0];
      is( ref $hash, 'HASH' , 'Array 0 is a hash' ) or return;
      ok( exists $hash->{xcpv_match} , 'Hash has xcpv_match field' ) or return;
      $hash = $hash->{xcpv_match};
      is( ref $hash, 'HASH' , 'XCPV is a hash' ) or return;
      ok( exists $hash->{CPV} , 'XCPV has CPV key') or return;
      $hash = $hash->{CPV};
      is( ref $hash , 'HASH', 'CPV is a Hash' ) or return;
      is_deeply( $hash, {
        CategoryName => $test->[0],
        PackageName  => $test->[1],
        Version => $test->[2],
      },  'Parse Data is as-expected');
    };

  }
};

done_testing;

