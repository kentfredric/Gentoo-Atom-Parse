use 5.010001;
use strict;
use warnings;

package miniparser;

# FILENAME: miniparser.pm
# CREATED: 07/11/11 16:49:50 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: a mock parser;

sub parse {
  my ( $input, $rule ) = @_;

  my $grammar;
  eval <<"EOF" or die;
  use Regexp::Grammars;
  use Gentoo::Atom::Parse::Grammar::Rules;

  \$grammar = qr{

  <[match]>+

  <extends: Gentoo::Atom::Parse::Grammar::Rules>
  <token: everything_else>
    (.*?)
  <token: match>
    <nocontext: >
    ( 
      <everything_else>$rule 
      |
      <everything_else>\$
    )
  }x;
EOF

  my $result = undef;
  my $matches = ( $input =~ $grammar );
  $result = \%/ if $matches;

  require Data::Dump;
  return [ $matches, $result, Data::Dump::pp($result) ];

}

sub strict_check_rx {
  my ( $words, $rx ) = @_;

  return { map { $_, ( $_ =~ $rx ? {%/} : 0 ) } @{$words} };
}

sub getrule {
  my $rulename = shift;
  state $load = do { require Gentoo::Atom::Parse::Grammar::Rules; 1; };
  return Gentoo::Atom::Parse::Grammar::Rules->can( '_' . $rulename )->();
}

sub strict_check {
  my ( $words, $rulename ) = @_;
  my $rule = getrule($rulename);
  return strict_check_rx( $words, qr/^$rule$/ );
}

sub check_re {
  local %/;
  my $match = $_[0] =~ $_[1];
  return {%/} if $match;
  return 0;
}
sub to_strict {  return qr{^$_[0]$}; }

sub parse_cpv {
  state $rule = do {  to_strict( getrule('CPV') ) };
  $_[1] = $rule;
  goto \&check_re;
}

sub check_cpv {
  my (@args) = @_;

  my $cat_E     = getrule('CategoryName');
  my $pkg_E     = getrule('PackageName');
  my $version_E = getrule('Version');
  my ( $cat, $pkg, $version ) = map { to_strict($_) } $cat_E, $pkg_E, $version_E;
  my $ecpv = qr{^$cat_E/$pkg_E-$version_E$};
  my $xcpv = to_strict( getrule('CPV') );

  #Data::Dump::pp($xcpv);
  my $checker = sub {
    my ( $c, $p, $v ) = @_;
    {
      cat => {
        input => $c,
        match => check_re( $c, $cat ),
      },
      pkg => {
        input => $p,
        match => check_re( $p, $pkg ),
      },
      version => {
        input => $v,
        match => check_re( $v, $version ),
      },
      ecpv_match => check_re( "$c/$p-$v", $ecpv ),
      xcpv_match => check_re( "$c/$p-$v", $xcpv ),
    };
  };
  return [ map { $checker->( @{$_} ) } @args ]

}

1;

