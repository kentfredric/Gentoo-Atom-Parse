use strict;
use warnings;
package Gentoo::Atom::Parse::Grammar::Rules;
# FILENAME: Rules.pm
# CREATED: 22/10/11 18:09:31 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: General rules for various parts of parsing Gentoo Atoms

use Regexp::Grammars;
use 5.010000;

require Data::Dump;

my $grammar;

BEGIN {
$grammar = qr{
  <grammar: Gentoo::Atom::Parse::Grammar::Rules>

  <nocontext: >
  
  <token: Int> ([0-9]+)

  <token: VersionNumber>
    ( 
      <[MATCH=Int]>
      (
        <[MATCH=(\.)]>
        <[MATCH=Int]>
      )*
    )
    <MATCH=(?{ join q{}, @$MATCH })>
  
  <token: VersionSuffix> (alpha|beta|pre|rc|p)

  <token: Version>
    (
      <[MATCH=VersionNumber]>
      <[MATCH=([a-zA-Z])]>?
      (
        <[MATCH=(_)]>
        <[MATCH=VersionSuffix]>
        <[MATCH=Int]>?
      )*
      (
        <[MATCH=(-r)]>
        <[MATCH=Int]>
      )?
    )
    <MATCH=(?{ join q{}, @$MATCH })>

  <token: PackageName>   ([a-z0-9A-Z_+-]+)
  
  <token: CategoryName>   ([a-z0-9A-Z_+-]+)

  <token: PV> 
  (<PackageName>-<Version>)

  <token: CPV>
  (<CategoryName>/<PackageName>-<Version>)

}x;
}

sub _grammar { 
   return $grammar;
}
sub _CPV {
  return qr{
    <extends: Gentoo::Atom::Parse::Grammar::Rules>
    <CPV>
  }x;
}

sub _PV {
  return qr{
    <extends: Gentoo::Atom::Parse::Grammar::Rules>
    <PV>
  }x;
}

sub _Int {
  return qr{
    <extends: Gentoo::Atom::Parse::Grammar::Rules>
    <Int>
  }x;
}
sub _VersionNumber {
  return qr{
    <extends: Gentoo::Atom::Parse::Grammar::Rules>
    <VersionNumber>
  }x;
}
sub _VersionSuffix {
  return qr{
    <extends: Gentoo::Atom::Parse::Grammar::Rules>
    <VersionSuffix>
  }x;
}
sub _Version {
  return qr{
    <extends: Gentoo::Atom::Parse::Grammar::Rules>
    <Version>
  }x;
}
sub _PackageName {
  return qr{
    <extends: Gentoo::Atom::Parse::Grammar::Rules>
    <PackageName>
  }x;
}
sub _CategoryName {
  return qr{
    <extends: Gentoo::Atom::Parse::Grammar::Rules>
    <CategoryName>
  }x;
}

1;


