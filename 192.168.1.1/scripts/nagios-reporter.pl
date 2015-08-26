#!/usr/bin/perl -w
#
# Nagios overnight/daily/weekly/monthly reporter
#
# Fetches Nagios report from web, processes HTML/CSS and emails to someone
# Written by Rob Moss, 2005-07-26, coding@mossko.com
#
# Use at your own risk, knoweledge of perl required.
#
# Version 1.3.1
# - Overnight, Daily, Weekly, Monthly reports
#

use strict;
use Getopt::Long;
use Net::SMTP;
use LWP::UserAgent;
use Date::Manip;


my $mailhost	=	'192.168.1.4';
my $maildomain	=	'renatea.gob.ar';
my $mailfrom	=	'root@renatea.gob.ar';
my $mailto	=	'root@renatea.gob.ar';
my $timeout	=	30;
my $mailsubject	=	'[NagiosGate] Reporte Mensual';
my $mailbody	=	'';
my $logfile	=	'/usr/local/nagios/var/mail.log';
my $debug	=	1;
my $type		=	'';
my $repdateprev;
my $reporturl;

my $nagssbody;
my $nagsssummary;

my $webuser		=	'nagiosadmin';							#	Set this to a read-only nagios user (not nagiosadmin!)
my $webpass		=	'mfatggs#7600#FED';							#	Set this to a read-only nagios user (not nagiosadmin!)
my $webbase		=	'https://nagios.renatea.gob.ar/nagios';	#	Set this to the base of Nagios web page
my $webcssembed =	0;


GetOptions (
	"debug=s"	=>	\$debug,
	"help"		=>	\&help,
	"type=s"	=>	\$type,
	"email=s"	=>	\$mailto,
	"embedcss"	=>	\$webcssembed,
);


if (not defined $type or $type eq "") {
	help();
	exit;
}
elsif ($type eq "overnight") {
	report_overnight();
}
elsif ($type eq "daily") {
	report_daily();
}
elsif ($type eq "weekly") {
	report_weekly();
}
elsif ($type eq "monthly") {
	report_monthly();
}
else {
	die("Unknown report type $type\n");
}


debug(1,"reporturl: [$reporturl]");

$mailbody = http_request($reporturl);
if ($webcssembed) {
	# Stupid hacks for dodgy notes
	$nagssbody		=	http_request("$webbase/stylesheets/summary.css");
	$nagsssummary = "<style type=\"text\/css\">\n";
	foreach ( split(/\n/,$nagssbody) ) {
		chomp;
		if (not defined $_ or $_ eq "" ) {
			next;
		}
		$nagsssummary .= "<!-- $_ -->\n";
	}
	$nagsssummary .= "</style>\n";
	$nagsssummary .= "<base href=\"$webbase/cgi-bin/\">\n";

	$mailbody =~ s@<LINK REL=\'stylesheet\' TYPE=\'text/css\' HREF=\'/stylesheets/common.css\'>@@;
	$mailbody =~ s@<LINK REL=\'stylesheet\' TYPE=\'text/css\' HREF=\'/stylesheets/summary.css\'>@$nagsssummary@;
}



open(FILE, "> /tmp/nagios-report-htmlout.html") or warn "can't open file /tmp/nagios-report-htmlout.html: $!\n";
print FILE $mailbody;
close FILE;



sendmail();


###############################################################################
sub help {
print <<_END_;

Nagios web->email reporter program.

$0 <args>

--help
	This screen

--email=<email>
	Send to this address instead of the default address
	"$mailto"

--type=overnight	
	Overnight report, from 17h last working day to Today (9am)
--type=daily
	Daily report, 09:00 last working day to Today (9am)
--type=weekly
	Weekly report, 9am 7 days ago, until 9am today (run at 9am friday!)
--type=monthly
	Monthly report, 1st of prev month at 9am to last day of month, 9am

--embedcss
	Downloads the CSS file and embeds it into the main HTML to enable 
	Lotus Notes to work (yet another reason to hate Notes)

_END_

exit 1;

}

###############################################################################
sub report_monthly {
	# This should be run on the 1st of every month
	$repdateprev = DateCalc("yesterday",1);
	debug(1,"repdateprev = $repdateprev");
#				#2006072116:48:37
	my ($repsday, $repsmonth, $repsyear, $repshour ) = 0;
	$repdateprev =~ /(\d\d\d\d)(\d\d)(\d\d)(.*)/;
	$repsday = 01;
	$repsmonth = $2;
	$repsyear = $1;
	$repshour = 0;

	my ($repeday, $repemonth, $repeyear, $repehour ) = 0;
	my $repdatenow = ParseDate("today");
	debug(1,"repdatenow = $repdatenow");
	$repdatenow =~ /(\d\d\d\d)(\d\d)(\d\d)(.*)/;
	$repeday = $3;
	$repemonth = $2;
	$repeyear = $1;
	$repehour = 0;

	$reporturl	=	"$webbase/cgi-bin/summary.cgi?report=1&displaytype=1&timeperiod=custom" .
						"&smon=$repsmonth&sday=$repsday&syear=$repsyear&shour=$repshour&smin=0&ssec=0" .
						"&emon=$repemonth&eday=$repeday&eyear=$repeyear&ehour=$repehour&emin=0&esec=0" .
						'&hostgroup=all&servicegroup=all&host=all&alerttypes=3&statetypes=2&hoststates=3&servicestates=56&limit=500';
	$mailsubject = "[NagiosGate] Reporte Mensual $repsmonth/$repsyear";

}

###############################################################################
sub report_weekly {
	# This should be run on Friday, 9am
	$repdateprev = Date_PrevWorkDay("today",5);
	debug(1,"repdateprev = $repdateprev");
				#2006072116:48:37
	my ($repsday, $repsmonth, $repsyear, $repshour ) = 0;
	$repdateprev =~ /(\d\d\d\d)(\d\d)(\d\d)(.*)/;
	$repsday = $3;
	$repsmonth = $2;
	$repsyear = $1;
	$repshour = 9;

	my ($repeday, $repemonth, $repeyear, $repehour ) = 0;
	my $repdatenow = ParseDate("today");
	debug(1,"repdatenow = $repdatenow");
	$repdatenow =~ /(\d\d\d\d)(\d\d)(\d\d)(.*)/;
	$repeday = $3;
	$repemonth = $2;
	$repeyear = $1;
	$repehour = 9;

	$reporturl	=	"$webbase/cgi-bin/summary.cgi?report=1&displaytype=1&timeperiod=custom" .
						"&smon=$repsmonth&sday=$repsday&syear=$repsyear&shour=$repshour&smin=0&ssec=0" .
						"&emon=$repemonth&eday=$repeday&eyear=$repeyear&ehour=$repehour&emin=0&esec=0" .
						'&hostgroup=all&servicegroup=all&host=all&alerttypes=3&statetypes=2&hoststates=3&servicestates=56&limit=500';
	$mailsubject = "[NagiosGate] Reporte Semanal $repsday/$repsmonth/$repsyear";

}


###############################################################################
sub report_daily {
	$repdateprev = Date_PrevWorkDay("today",1);
	debug(1,"repdateprev = $repdateprev");
				#2006072116:48:37
	my ($repsday, $repsmonth, $repsyear, $repshour ) = 0;
	$repdateprev =~ /(\d\d\d\d)(\d\d)(\d\d)(.*)/;
	$repsday = $3;
	$repsmonth = $2;
	$repsyear = $1;
	$repshour = 7;

	my ($repeday, $repemonth, $repeyear, $repehour ) = 0;
	my $repdatenow = ParseDate("today");
	debug(1,"repdatenow = $repdatenow");
	$repdatenow =~ /(\d\d\d\d)(\d\d)(\d\d)(.*)/;
	$repeday = $3;
	$repemonth = $2;
	$repeyear = $1;
	$repehour = 7;

	$reporturl	=	"$webbase/cgi-bin/summary.cgi?report=1&displaytype=1&timeperiod=custom" .
						"&smon=$repsmonth&sday=$repsday&syear=$repsyear&shour=$repshour&smin=0&ssec=0" .
						"&emon=$repemonth&eday=$repeday&eyear=$repeyear&ehour=$repehour&emin=0&esec=0" .
						'&hostgroup=all&servicegroup=all&host=all&alerttypes=3&statetypes=2&hoststates=3&servicestates=56&limit=500';
	$mailsubject = "[NagiosGate] Reporte Diario $repsday/$repsmonth/$repsyear";

}

###############################################################################
sub report_overnight {
	$repdateprev = Date_PrevWorkDay("today",1);
	debug(1,"repdateprev = $repdateprev");
				#2006072116:48:37
	my ($repsday, $repsmonth, $repsyear, $repshour ) = 0;
	$repdateprev =~ /(\d\d\d\d)(\d\d)(\d\d)(.*)/;
	$repsday = $3;
	$repsmonth = $2;
	$repsyear = $1;
	$repshour = 17;

	my ($repeday, $repemonth, $repeyear, $repehour ) = 0;
	my $repdatenow = ParseDate("today");
	debug(1,"repdatenow = $repdatenow");
	$repdatenow =~ /(\d\d\d\d)(\d\d)(\d\d)(.*)/;
	$repeday = $3;
	$repemonth = $2;
	$repeyear = $1;
	$repehour = 9;

	$reporturl	=	"$webbase/cgi-bin/summary.cgi?report=1&displaytype=1&timeperiod=custom" .
						"&smon=$repsmonth&sday=$repsday&syear=$repsyear&shour=$repshour&smin=0&ssec=0" .
						"&emon=$repemonth&eday=$repeday&eyear=$repeyear&ehour=$repehour&emin=0&esec=0" .
						'&hostgroup=all&servicegroup=all&host=all&alerttypes=3&statetypes=2&hoststates=3&servicestates=56&limit=500';
	$mailsubject = "Nagios overnight alerts from $repsday/$repsmonth/$repsyear ${repshour}h to present";

}

###############################################################################
sub http_request {
	my $ua;
	my $req;
	my $res;

	my $geturl = shift;
	if (not defined $geturl or $geturl eq "") {
		warn "No URL defined for http_request\n";
		return 0;
	}
	$ua = LWP::UserAgent->new;
	$ua->agent("Nagios Report Generator " . $ua->agent);
	$req = HTTP::Request->new(GET => $geturl);
	$req->authorization_basic($webuser, $webpass);
	$req->header(	'Accept'			=>	'text/html',
					'Content_Base'		=>	$webbase,
				);

	# send request
	$res = $ua->request($req);

	# check the outcome
	if ($res->is_success) {
		debug(1,"Retreived URL successfully");
		return $res->decoded_content;
	}
	else {
		print "Error: " . $res->status_line . "\n";
		return 0;
	}
}

###############################################################################
sub debug {
	my ($lvl,$msg) = @_;
	if ( defined $debug and $lvl <= $debug ) {
		chomp($msg);
		print localtime(time) .": $msg\n";
	}
	return 1;
}

#########################################################
sub sendmail {
	my $smtp = Net::SMTP->new(
			$mailhost,
			Hello => $maildomain,
			Timeout => $timeout,
			Debug   => $debug,
		);

	$smtp->mail($mailfrom);
	$smtp->to($mailto);

	$smtp->data();
	$smtp->datasend("To: $mailto\n");
	$smtp->datasend("From: $mailfrom\n");
	$smtp->datasend("Subject: $mailsubject\n");
	$smtp->datasend("MIME-Version: 1.0\n");
	$smtp->datasend("Content-type: multipart/mixed; boundary=\"boundary\"\n");
	$smtp->datasend("\n");
	$smtp->datasend("This is a multi-part message in MIME format.\n");
	$smtp->datasend("--boundary\n");
	$smtp->datasend("Content-type: text/html\n");
	$smtp->datasend("Content-Disposition: inline\n");
	$smtp->datasend("Content-Description: Nagios report\n");
	$smtp->datasend("$mailbody\n");
	$smtp->datasend("--boundary\n");
	$smtp->datasend("Content-type: text/plain\n");
	$smtp->datasend("Please read the attatchment\n");
	$smtp->datasend("--boundary--\n");


	$smtp->dataend();

	$smtp->quit;
}



