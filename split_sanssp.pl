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
            print "\n";
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
	    print "$mot\n";
    }elsif (($pr1 eq "CONJ") && ($pr2 eq "none") && ($pr3 eq "none")){
	# il n'y a pas de mots composés d'une seule lettre (après séparation du w)
	if (($mot =~ m/^w/) && ($mot ne "w") && ($len > 2)){
	    my $restw=substr($mot, 1);
	    print "w+$restw\n";
	}elsif (($mot =~ m/^f/) && ($mot ne "f") && ($len > 2)){
	    my $restf=substr($mot, 1);
            print "f+$restf\n";
	}else{
	    print "$mot\n";
	}
    }
	
    if ($pr2 eq "PREP"){
	if (($pr1 eq "none") && ($pr3 eq "none")){
		if (($pos eq "prep") && ($mot =~ m/HwAly/)){
		    my $restpos=(split (/HwAly/,$mot))[0];
		    print "$restpos+HwAly\n";
		}elsif ($pos eq "prep"){
		    print "$mot\n";
		}elsif (($mot =~ m/^b/) && ($len > 2) && ($mot ne "bEdmA")){
		# ne pas segmenter les mots comme bh mais normalemnt pour bh pos=prep
		    my $restb=substr($mot, 1);
		    print "b+$restb\n";
		}elsif ($mot =~ m/^l/){
		    if ($mot eq "l"){
			    print "l+\n";
		    }else{			
			    my $restl=substr($mot, 1);
			    print "l+$restl\n";
		    }
		}elsif ($mot =~ m/^k/){
		    if ($mot eq "k"){
		            print "k+$restk\n";
		    }else{
			    my $restk=substr($mot, 1);
		            print "k+$restk\n";
		    }
		}else{
		    print "$mot\n";
		}
	}
	if (($pr1 eq "CONJ") && ($pr3 eq "none")){
		if (($pos eq "prep") && ($mot =~ m/^w/)){
		    if ($mot eq "w"){
			print "w+\n";
			#print POSFILE "CONJ ";
		    }else{
			my $restwprep=substr($mot, 1);
			print "w+$restwprep\n";
			#print POSFILE "CONJ $pos ";
		    }
		}elsif ($mot =~ m/^wb/){
		    if ($mot eq "wb"){
			print "w+b+\n";
		        #print POSFILE "CONJ PREP ";
		    }else{
		    	my $restwb=substr($mot, 2);#(split (/wb/,$mot))[1];
		    	print "w+b+$restwb\n";
		    	#print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^wl/){
		    if ($mot eq "wl"){
			print "w+l+\n";
		    	#print POSFILE "CONJ PREP ";
		    }else{
		    	my $restwl=substr($mot, 2);#(split (/wl/,$mot))[1];
		    	print "w+l+$restwl\n";
		    	#print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^wk/){
		    if ($mot eq "wk"){
			print "w+k+\n";
		    	#print POSFILE "CONJ PREP ";
		    }else{
			my $restwk=substr($mot, 2);#(split (/wk/,$mot))[1];
	            	print "w+k+$restwk\n";
		    	#print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^w/){
		    if ($mot eq "w"){
			print "w+\n";
		    	#print POSFILE "CONJ ";
		    }else{
			my $restw=substr($mot, 1);
		    	print "w+$restw\n";
		    	#print POSFILE "CONJ $pos ";
		    }
		}elsif (($pos eq "prep") && ($mot =~ m/^f/)){
		    if ($mot eq "f"){
			print "f+\n";
			#print POSFILE "CONJ ";
		    }else{
			my $restwprepf=substr($mot, 1);
			print "f+$restwprepf\n";
			#print POSFILE "CONJ $pos ";
	            }
		}elsif ($mot =~ m/^fb/){
		    if ($mot eq "fb"){
	  		print "f+b+\n";
		    	#print POSFILE "CONJ PREP ";
		    }else{
			my $restfb=substr($mot, 2);#(split (/fb/,$mot))[1];
		    	print "f+b+$restfb\n";
		    	#print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^fl/){
		    if ($mot eq "fl"){
			print "f+l+\n";
			#print POSFILE "CONJ PREP ";
		    }else{
		   	my $restfl=substr($mot, 2);#(split (/fl/,$mot))[1];
		    	print "f+l+$restfl\n";
		    	#print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^fk/){
		    if ($mot eq "fk"){
			print "f+k+\n";
			#print POSFILE "CONJ PREP ";
		    }else{
		    	my $restfk=substr($mot, 2);#(split (/fk/,$mot))[1];
	            	print "f+k+$restfk\n";
		    	#print POSFILE "CONJ PREP $pos ";
		    }
		}elsif ($mot =~ m/^f/){
		    if ($mot eq "f"){
		    	print "f+\n";
		    	#print POSFILE "CONJ ";
		    }else{
		    	my $restf=substr($mot, 1);
		    	print "f+$restf\n";
		    	#print POSFILE "CONJ $pos ";
		    }
		}
	}
    }
    if ($pr2 eq "FUT"){
	if (($pr1 eq "none") && ($pr3 eq "none")){
		my $rests=substr($mot, 1);#(split (/s/,$mot))[1];
		print "s+$rests\n";
		#print POSFILE "FUT $pos ";
	}elsif($mot =~ m/^s/){
		print "$mot\n";
		#print POSFILE "$pos ";
	}
	if (($pr1 eq "CONJ") && ($pr3 eq "none")){
		if ($mot =~ m/^ws/){
			if ($mot eq "ws"){
				print "w+s+\n";
				#print POSFILE "CONJ FUT ";
			}else{
				my $restws=substr($mot, 2);#(split (/ws/,$mot))[1];
				print "w+s+$restws\n";
				#print POSFILE "CONJ FUT $pos ";
			}
		}elsif ($mot =~ m/^fs/){
			if ($mot eq "fs"){
				print "f+s+\n";
				#print POSFILE "CONJ FUT ";
			}else{	
				my $restfs=substr($mot, 2);#(split (/fs/,$mot))[1];
				print "f+s+$restfs\n";
				#print POSFILE "CONJ FUT $pos ";
			}
		}else{
			print "$mot\n";
			#print POSFILE "$pos ";
		}

	}
    }
    if ($pr2 eq "SUB"){
	if (($pr1 eq "none") && ($pr3 eq "none") && ($mot =~ m/^l/)){
		if ($mot eq "l"){
			print "l+\n";
			#print POSFILE "SUB ";
		}else{
			my $restl=substr($mot, 1);#(split (/s/,$mot))[1];
			print "l+$restl\n";
			#print POSFILE "SUB $pos ";
		}
	}elsif (($pr1 eq "CONJ") && ($pr3 eq "none")){
		if ($mot =~ m/^wl/){
			if ($mot eq "wl"){
				print "w+l+\n";
				#print POSFILE "CONJ SUB ";
			}else{
				my $restwl=substr($mot, 2);#(split (/ws/,$mot))[1];
				print "w+l+$restwl\n";
				#print POSFILE "CONJ SUB $pos ";
			}
		}elsif ($mot =~ m/^fl/){
			if ($mot eq "fl"){
				print "f+l+\n";
				#print POSFILE "CONJ SUB $pos ";
			}else{
				my $restfl=substr($mot, 2);#(split (/fs/,$mot))[1];
				print "f+l+$restfl\n";
				#print POSFILE "CONJ SUB $pos ";
			}
		}else{
			print "$mot\n";
			#print POSFILE "$pos ";
		}

	}else{
		print "$mot\n";
		#print POSFILE "$pos ";
	}
		
    }
    if ($pr3 eq "DET"){
	if (($pr1 eq "none") && ($pr2 eq "none")){
		my $restal=substr($mot, 2);#(split (/Al/,$mot))[1];
		print "$mot\n";#Al$restal ";
		#print POSFILE "$pos ";
	}
	if (($pr1 eq "CONJ") && ($pr2 eq "none")){
		if ($mot =~ m/^wAl/){
			my $restwal=substr($mot, 1);#(split (/wAl/,$mot))[1];
			print "w+$restwal\n";
			#print POSFILE "CONJ $pos ";
		}elsif ($mot =~ m/^fAl/){
			my $restfal=substr($mot, 1);#(split (/fAl/,$mot))[1];
			print "f+$restfal\n";
			#print POSFILE "CONJ $pos ";
		}else{
			print "$mot\n";
			#print POSFILE "$pos ";
		}
	}
	if (($pr1 eq "none") && ($pr2 eq "PREP")){
		if ($mot =~ m/^bAl/){
			my $restbal=substr($mot, 1);#(split (/bAl/,$mot))[1];
			print "b+$restbal\n";
			#print POSFILE "PREP $pos ";
		}elsif ($mot =~ m/^b/){
			if ($mot eq "b"){
				print "b+\n";		
				#print POSFILE "PREP ";
			}else{	
				my $restb=substr($mot, 1);#(split (/bAl/,$mot))[1];
				print "b+$restb\n";		
				#print POSFILE "PREP $pos ";
			}
		}
		elsif ($mot =~ m/^kAl/){
			my $restkal=substr($mot, 1);#(split (/kAl/,$mot))[1];
			print "k+$restkal\n";
			#print POSFILE "PREP $pos ";
		}
		elsif ($mot =~ m/^ll/){
			my $restll=substr($mot, 2);#(split (/ll/,$mot))[1];
			print "l+Al$restll\n";
			#print POSFILE "PREP $pos ";
		     
		}elsif ($mot =~ m/^l/){
			if ($mot eq "l"){
				print "l+\n";
				#print POSFILE "PREP ";
			}else{
				my $restl=substr($mot, 1);#(split (/ll/,$mot))[1];
				print "l+$restl\n";
				#print POSFILE "PREP $pos ";
			}
		}else{
			print "$mot\n";
			#print POSFILE "$pos ";
		}
				
	}
	if (($pr1 eq "none") && ($pr2 eq "SUB")){
		if ($mot =~ m/^ll/){
			my $restll=substr($mot, 2);#(split (/ll/,$mot))[1];
			print "l+Al$restll\n";
			#print POSFILE "SUB $pos ";
		}
	}
	if (($pr1 eq "CONJ") && ($pr2 eq "PREP")){
		if ($mot =~ m/^wbAl/){
			my $restwbal=substr($mot, 2);#(split (/wbAl/,$mot))[1];
			print "w+b+$restwbal\n";
			#print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^wkAl/){
			my $restwkal=substr($mot, 2);#(split (/wkAl/,$mot))[1];
			print "w+k+$restwkal\n";
			#print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^wll/){
			my $restwll=substr($mot, 3);#(split (/wll/,$mot))[1];
			print "w+l+Al$restwll\n";
			#print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^fbAl/){
			my $restfbal=substr($mot, 2);#(split (/fbAl/,$mot))[1];
			print "f+b+$restfbal\n";
			#print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^fkAl/){
			my $restfkal=substr($mot, 2);#(split (/fkAl/,$mot))[1];
			print "f+k+$restfkal\n";
			#print POSFILE "CONJ PREP $pos ";
		}
		if ($mot =~ m/^fll/){
			my $restfll=substr($mot, 3);#(split (/fll/,$mot))[1];
			print "f+l+Al$restfll\n";
			#print POSFILE "CONJ PREP $pos ";
		}

	}
	if (($pr1 eq "CONJ") && ($pr2 eq "SUB")){
		if ($mot =~ m/^wll/){
			my $restwll=substr($mot, 3);#(split (/wll/,$mot))[1];
			print "w+l+Al$restwll\n";
			#print POSFILE "CONJ SUB $pos ";
		}
		if ($mot =~ m/^fll/){
			my $restfll=substr($mot, 3);#(split (/fll/,$mot))[1];
			print "f+l+Al$restfll\n";
			#print POSFILE "CONJ SUB $pos ";
		}

	}
    }
	
    # print "mot $mot, pos:$pos, pr1:$pr1, pr2:$pr2, pr3:$pr3\n";
#	print "\n";
   } 
}
close TOSPLIT;
close POSFILE;
