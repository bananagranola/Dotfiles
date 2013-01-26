#!/usr/bin/perl

use XML::Simple;
use LWP;
#use Data::Dumper;

# retrieve XML data
my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new( GET => "http://gdata.youtube.com/feeds/api/users/gophersvids/uploads" );
my $res = $ua->request( $req );
$xml = new XML::Simple (KeyAttr=>[]);
$data = $xml->XMLin( $res->content );
#print Dumper($data) . "\n";

# parse XML data
foreach $id (@{$data->{entry}}) {
	$url;
	for $li (@{$id->{link}}) {
		if ( $li->{rel} eq 'alternate' ) {
			$url = $li->{href};
		}	
	}
	printf "%s\n%s\n\n",
	$id->{title}{content},
	$url;

}
