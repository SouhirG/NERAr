#!/usr/bin/perl

#################################################################################
#NERAr is licensed under the term of the two-clause BSD Licence:
#
#    Copyright (c) 2013  CNRS
#    All rights reserved.
#
#    Redistribution and use in source and binary forms, with or without
#    modification, are permitted provided that the following conditions are met:
#        * Redistributions of source code must retain the above copyright
#          notice, this list of conditions and the following disclaimer.
#        * Redistributions in binary form must reproduce the above copyright
#          notice, this list of conditions and the following disclaimer in the
#          documentation and/or other materials provided with the distribution.
#
#    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
#    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#    POSSIBILITY OF SUCH DAMAGE.
#################################################################################
#######################################################################################################################
# Author: Souhir GAHBICHE
# Description : Splits off arabic text depending on the attributed tag
#               Separe :
#		- w+, f+ if pr1=CONJ
#		- b+, k+, l+ if pr2=PREP
#		- l+ if pr2=SUB
#		- s+ if pr2=FUT
#		Replace ll par l+Al if l is a prefix
#######################################################################################################################

#my $filetosplit="/people/souhir/tmp/wapiti/testtest";
my @splitline,@splitlabel;
my $mot, $label;
my $pos, $pr1, $pr2, $pr3;

my $filetosplit=$ARGV[0];
my $POSfile=$filetosplit.".pos";
my $len;
my $chps;
my $pred;
binmode STDIN, ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';
binmode STDERR, ':encoding(UTF-8)';

open POSFILE, "> $POSfile" or die "$POSfile does not exist";

open(TOSPLIT, "<:encoding(UTF-8)", "$filetosplit");
while ($line = <TOSPLIT>){
    if ($line eq "\n"){
	print POSFILE "\n";
	print "\n";
    }
    @splitline=(split (/\s/,$line));
    $mot = $splitline[0];
    $len = length ($mot);
    if ($line ne ""){
	my $sp = split(/\s/,$line) -1;
	my $tab = split(/\t/,$line) -1;
	$chps = $sp + $tab;
	$pred = $chps -1;
    }
    $label = $splitline[1];
    if ($mot eq "emhtyline"){
            print "";
    }else{
	@splitlabel=(split (/\+/,$label));
	my $long=@splitlabel;
	$pr1=$pr2=$pr3="";
	if ($long eq "3"){
		$pr1 = $splitlabel[0];
		$pr2 = $splitlabel[1];
		$pr3 = $splitlabel[2];
	}elsif ($long eq "4"){
		$pos = $splitlabel[0];
		$pr1 = $splitlabel[1];
		$pr2 = $splitlabel[2];
		$pr3 = $splitlabel[3];
	}

    if (($pr1 eq "none") && ($pr2 eq "none") && ($pr3 eq "none")){
	    print "$mot ";
	    print POSFILE "$pos ";
    }elsif (($pr1 eq "CONJ") && ($pr2 eq "none") && ($pr3 eq "none")){
	# il n'y a pas de mots composés d'une seule lettre (après séparation du w)
	if (($mot =~ m/^w/) && ($mot ne "w") && ($len > 2)){
	    my $restw=substr($mot, 1);
	    print "w+ $restw ";
	    print POSFILE "CONJ $pos ";
	}elsif (($mot =~ m/^f/) && ($mot ne "f") && ($len > 2)){
	    my $restf=substr($mot, 1);
            print "f+ $restf ";
	    print POSFILE "CONJ $pos ";
	}else{
	    print "$mot ";
	    print POSFILE "$pos ";
	}
    }
	
    if ($pr2 eq "PREP"){
	if (($pr1 eq "none") && ($pr3 eq "none")){
		if (($pos eq "prep") && ($mot =~ m/HwAly/)){
		    my $restpos=(split (/HwAly/,$mot))[0];
		    print "$restpos+ HwAly ";
		    print POSFILE "PREP prep ";
		}elsif ($pos eq "prep"){
		    print "$mot ";
		    print POSFILE "$pos ";
		}elsif (($mot =~ m/^b/) && ($len > 2) && ($mot ne "bEdmA")){
		# ne pas segmenter les mots comme bh mais normalemnt pour bh pos=prep
		    my $restb=substr($mot, 1);
		    print "b+ $restb ";
		    print POSFILE "PREP $pos ";
		}elsif ($mot =~ m/^l/){
		    if ($mot eq "l"){
			    print "l+ ";
			    print POSFILE "PREP ";
		    }else{			
			    my $restl=substr($mot, 1);
			    print "l+ $restl ";
			    print POSFILE "PREP $pos ";
		    }
		}elsif ($mot =~ m/^k/){
		    if ($mot eq "k"){
		            print "k+ $restk ";
			    print POSFILE "PREP $pos ";
		    }else{
			    my $restk=substr($mot, 1);
		            print "k+ $restk ";
			    print POSFILE "PREP $pos ";
		    }
		}else{
		    print "$mot ";
		    print POSFILE "$pos ";
		}
	}
	if (($pr1 eq "CONJ") && ($pr3 eq "none")){
		if (($pos eq "prep") && ($mot =~ m/^w/)){
		    if ($mot eq "w"){
			print "w+ ";
			print POSFILE "CONJ ";
		    }else{
			my $restwprep=substr($mot, 1);
			print "w+ $restwprep ";
			print POSFILE "CONJ $pos ";
		    }
		}elsif ($mot =~ m/^wb/){
		    if ($mot eq "wb"){
			print "w+ b+ ";
		        print POSFILE "CONJ PREP ";
		    }else{
		    	my $restwb=substr($mot, 2);
		    	print "w+ b+ $restwb ";
		    	print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^wl/){
		    if ($mot eq "wl"){
			print "w+ l+ ";
		    	print POSFILE "CONJ PREP ";
		    }else{
		    	my $restwl=substr($mot, 2);
		    	print "w+ l+ $restwl ";
		    	print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^wk/){
		    if ($mot eq "wk"){
			print "w+ k+ ";
		    	print POSFILE "CONJ PREP ";
		    }else{
			my $restwk=substr($mot, 2);
	            	print "w+ k+ $restwk ";
		    	print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^w/){
		    if ($mot eq "w"){
			print "w+ ";
		    	print POSFILE "CONJ ";
		    }else{
			my $restw=substr($mot, 1);
		    	print "w+ $restw ";
		    	print POSFILE "CONJ $pos ";
		    }
		}elsif (($pos eq "prep") && ($mot =~ m/^f/)){
		    if ($mot eq "f"){
			print "f+ ";
			print POSFILE "CONJ ";
		    }else{
			my $restwprepf=substr($mot, 1);
			print "f+ $restwprepf ";
			print POSFILE "CONJ $pos ";
	            }
		}elsif ($mot =~ m/^fb/){
		    if ($mot eq "fb"){
	  		print "f+ b+ ";
		    	print POSFILE "CONJ PREP ";
		    }else{
			my $restfb=substr($mot, 2);
		    	print "f+ b+ $restfb ";
		    	print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^fl/){
		    if ($mot eq "fl"){
			print "f+ l+ ";
			print POSFILE "CONJ PREP ";
		    }else{
		   	my $restfl=substr($mot, 2);
		    	print "f+ l+ $restfl ";
		    	print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^fk/){
		    if ($mot eq "fk"){
			print "f+ k+ ";
			print POSFILE "CONJ PREP ";
		    }else{
		    	my $restfk=substr($mot, 2);
	            	print "f+ k+ $restfk ";
		    	print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^f/){
		    if ($mot eq "f"){
		    	print "f+ ";
		    	print POSFILE "CONJ ";
		    }else{
		    	my $restf=substr($mot, 1);
		    	print "f+ $restf ";
		    	print POSFILE "CONJ $pos ";
		    }
		}
	}
    }
    if ($pr2 eq "FUT"){
	if (($pr1 eq "none") && ($pr3 eq "none")){
		my $rests=substr($mot, 1);
		print "s+ $rests ";
		print POSFILE "FUT $pos ";
	}elsif($mot =~ m/^s/){
		print "$mot ";
		print POSFILE "$pos ";
	}
	if (($pr1 eq "CONJ") && ($pr3 eq "none")){
		if ($mot =~ m/^ws/){
			if ($mot eq "ws"){
				print "w+ s+ ";
				print POSFILE "CONJ FUT ";
			}else{
				my $restws=substr($mot, 2);
				print "w+ s+ $restws ";
				print POSFILE "CONJ FUT $pos ";
			}
		}elsif ($mot =~ m/^fs/){
			if ($mot eq "fs"){
				print "f+ s+ ";
				print POSFILE "CONJ FUT ";
			}else{	
				my $restfs=substr($mot, 2);
				print "f+ s+ $restfs ";
				print POSFILE "CONJ FUT $pos ";
			}
		}else{
			print "$mot ";
			print POSFILE "$pos ";
		}

	}
    }
    if ($pr2 eq "SUB"){
	if (($pr1 eq "none") && ($pr3 eq "none") && ($mot =~ m/^l/)){
		if ($mot eq "l"){
			print "l+ ";
			print POSFILE "SUB ";
		}else{
			my $restl=substr($mot, 1);
			print "l+ $restl ";
			print POSFILE "SUB $pos ";
		}
	}elsif (($pr1 eq "CONJ") && ($pr3 eq "none")){
		if ($mot =~ m/^wl/){
			if ($mot eq "wl"){
				print "w+ l+ ";
				print POSFILE "CONJ SUB ";
			}else{
				my $restwl=substr($mot, 2);
				print "w+ l+ $restwl ";
				print POSFILE "CONJ SUB $pos ";
			}
		}elsif ($mot =~ m/^fl/){
			if ($mot eq "fl"){
				print "f+ l+ ";
				print POSFILE "CONJ SUB $pos ";
			}else{
				my $restfl=substr($mot, 2);
				print "f+ l+ $restfl ";
				print POSFILE "CONJ SUB $pos ";
			}
		}else{
			print "$mot ";
			print POSFILE "$pos ";
		}

	}else{
		print "$mot ";
		print POSFILE "$pos ";
	}
		
    }
    if ($pr3 eq "DET"){
	if (($pr1 eq "none") && ($pr2 eq "none")){
		my $restal=substr($mot, 2);
		print "$mot ";
		print POSFILE "$pos ";
	}
	if (($pr1 eq "CONJ") && ($pr2 eq "none")){
		if ($mot =~ m/^wAl/){
			my $restwal=substr($mot, 1);
			print "w+ $restwal ";
			print POSFILE "CONJ $pos ";
		}elsif ($mot =~ m/^fAl/){
			my $restfal=substr($mot, 1);
			print "f+ $restfal ";
			print POSFILE "CONJ $pos ";
		}else{
			print "$mot ";
			print POSFILE "$pos ";
		}
	}
	if (($pr1 eq "none") && ($pr2 eq "PREP")){
		if ($mot =~ m/^bAl/){
			my $restbal=substr($mot, 1);
			print "b+ $restbal ";
			print POSFILE "PREP $pos ";
		}elsif ($mot =~ m/^b/){
			if ($mot eq "b"){
				print "b+ ";		
				print POSFILE "PREP ";
			}else{	
				my $restb=substr($mot, 1);
				print "b+ $restb ";		
				print POSFILE "PREP $pos ";
			}
		}
		elsif ($mot =~ m/^kAl/){
			my $restkal=substr($mot, 1);
			print "k+ $restkal ";
			print POSFILE "PREP $pos ";
		}
		elsif ($mot =~ m/^ll/){
			my $restll=substr($mot, 2);
			print "l+ Al$restll ";
			print POSFILE "PREP $pos ";
		     
		}elsif ($mot =~ m/^l/){
			if ($mot eq "l"){
				print "l+ ";
				print POSFILE "PREP ";
			}else{
				my $restl=substr($mot, 1);
				print "l+ $restl ";
				print POSFILE "PREP $pos ";
			}
		}else{
			print "$mot ";
			print POSFILE "$pos ";
		}
				
	}
	if (($pr1 eq "none") && ($pr2 eq "SUB")){
		if ($mot =~ m/^ll/){
			my $restll=substr($mot, 2);
			print "l+ Al$restll ";
			print POSFILE "SUB $pos ";
		}
	}
	if (($pr1 eq "CONJ") && ($pr2 eq "PREP")){
		if ($mot =~ m/^wbAl/){
			my $restwbal=substr($mot, 2);
			print "w+ b+ $restwbal ";
			print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^wkAl/){
			my $restwkal=substr($mot, 2);
			print "w+ k+ $restwkal ";
			print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^wll/){
			my $restwll=substr($mot, 3);
			print "w+ l+ Al$restwll ";
			print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^fbAl/){
			my $restfbal=substr($mot, 2);
			print "f+ b+ $restfbal ";
			print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^fkAl/){
			my $restfkal=substr($mot, 2);
			print "f+ k+ $restfkal ";
			print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^fll/){
			my $restfll=substr($mot, 3);
			print "f+ l+ Al$restfll ";
			print POSFILE "CONJ PREP $pos ";
		}

	}
	if (($pr1 eq "CONJ") && ($pr2 eq "SUB")){
		if ($mot =~ m/^wll/){
			my $restwll=substr($mot, 3);
			print "w+ l+ Al$restwll ";
			print POSFILE "CONJ SUB $pos ";
		}
		if ($mot =~ m/^fll/){
			my $restfll=substr($mot, 3);
			print "f+ l+ Al$restfll ";
			print POSFILE "CONJ SUB $pos ";
		}

	}
    }
	
   } 
}
close TOSPLIT;
close POSFILE;
