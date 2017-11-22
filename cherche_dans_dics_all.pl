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
# Description : Propose translations extracted from bilingual dictionaries.
#######################################################################################################################

my $dico_LOC="dics/dico-bi-ar-fr.LOC.norm";
my $dico_NAMES="dics/dico-bi-ar-fr.PERS.norm";
my $dico_ORG="dics/dico-bi-ar-fr.ORG.norm";
my (%dico_hash_LocGaz, %dico_hash_PersGaz, %dico_hash_OrgGaz, %dico_hash_names, %dico_hash_wnoms, %dico_hash_wpays, %dico_hash_wpers, %dico_hash_wprenoms, %dico_hash_wregions, %dico_hash_LOC, %dico_hash_org, %dico_hash_geonames); 
my $line;

my $file=$ARGV[0]; #fichier contenant toutes les prédictions
my $taggedfile=$ARGV[1];
my $n=0;

my $nbpersfound=0;
my $nblocfound=0;
my $nborgfound=0;

open DICO_LOCs, "< $dico_LOC" or die "$dico_LOC does not exist";
while ($line = <DICO_LOCs>){
    $line=~s/\n//;
	$ar=(split(/\t/,$line))[0];
	$fr=(split(/\t/,$line))[1];
    if (!exists $dico_hash_LOC{$line}){
	if (exists ($dico_hash_LOC{$ar})){
		$n++;
		$dico_hash_LOC{$ar.$n}=$fr;
	}else{
		$n=0;
		$dico_hash_LOC{$ar}=$fr;
	}
	#print "hash de $ar est $fr\n";
    }
}
close DICO_LOCs;


open DICO_names, "< $dico_NAMES" or die "$dico_NAMES does not exist";
while ($line = <DICO_names>){
    $line=~s/\n//;
	$ar=(split(/\t/,$line))[0];
	$fr=(split(/\t/,$line))[1];
    if (!exists $dico_hash_names{$line}){
	if (exists ($dico_hash_names{$ar})){
		$n++;
		$dico_hash_names{$ar.$n}=$fr;
	}else{
		$n=0;
		$dico_hash_names{$ar}=$fr;
	}
    }
}
close DICO_names;


open DICO_orgs, "< $dico_ORG" or die "$dico_ORG does not exist";
while ($line = <DICO_orgs>){
    $line=~s/\n//;
	$ar=(split(/\t/,$line))[0];
	$fr=(split(/\t/,$line))[1];
    if (!exists $dico_hash_org{$line}){
	if (exists ($dico_hash_org{$ar})){
		$n++;
		$dico_hash_org{$ar.$n}=$fr;
	}else{
		$n=0;
		$dico_hash_org{$ar}=$fr;
	}
    }
}
close DICO_orgs;

my $i=0; 
my @array=();
my @nbelmts;
my $size;
my $fileout= $file.out;
open FILE, "< $file" or die "$file does not exist";
open FILEOUT, "> $fileout" or die "$fileout does not exist";
while ($line = <FILE>){
	@nbelmts=(split(/ /,$line));
	$size=@nbelmts;
	if (($size eq "1")){
		chomp($line);
		print FILEOUT "$line O\n";
	}elsif (($size eq "2") && ($line =~ m/^ O/)){
		chomp($line);
	}else{
		chomp($line);
		print FILEOUT "$line\n";
	}
	
}
close FILEOUT;
close FILE;
my $precprec;
my $motprec;
my $fileen= $file.en;
open FILEOUT, "< $fileout" or die "$fileout does not exist";
open FILEEN, "> $fileen" or die "$fileen does not exist";
while ($line = <FILEOUT>){
	chomp($line);
	$line=~s/B-MISC/O/g;
	$line=~s/I-MISC/O/g;
	my $mot=(split(/ /,$line))[0];
	my $tag=(split(/ /,$line))[1];
	if (($tag eq "O") || ($tag eq "")){
		if (($prec =~ m/^I/) || ($prec =~ m/^B/)){
			if ($prec =~ m/LOC/){
				print FILEEN "LOC\n";
			}elsif ($prec =~ m/PERS/){
				print FILEEN "PERS\n";
			}elsif ($prec =~ m/ORG/){
				print FILEEN "ORG\n";
			}
		}
		$motprec=$mot;
		$precprec=$prec;
		$prec=$tag;
		print FILEEN "$line \n";
	}elsif ($tag =~ m/^B/){
		if ($prec =~ m/^B/){
			if ($prec eq "B-LOC"){
				print FILEEN "LOC\n";
			}elsif ($prec eq "B-PERS"){
				print FILEEN "PERS\n";
			}elsif ($prec eq "B-ORG"){
				print FILEEN "ORG\n";
			}
		}
		$motprec=$mot;
		$precprec=$prec;
		$prec=$tag;
		print FILEEN "$mot ";
	}elsif (($tag =~ m/^I/) && (($prec =~ m/^B/) || ($prec =~ m/^I/))){
		$motprec=$mot;
		$precprec=$prec;
		$prec=$tag;
		print FILEEN "$mot ";
	}elsif (($tag =~ m/^I/) && ($prec =~ m/^O/)){
		
		
		$motprec=$mot;
		$precprec=$prec;
		$prec=$tag;
		print FILEEN "$mot ";
	}elsif ($tag =~ m/^I/){
		print FILEEN "$mot ";
	}else{
		print FILEEN "\n";
	}
}
close FILEEN;
close FILEOUT;

qx{perl -i -p -e 's/ \n/\n/g;' $fileen};
qx{perl -i -p -e 's/ \n/\n/g;' $fileen};

my $e;
open FILEEN, "< $fileen" or die "$fileen does not exist";
open FILETAG, "> $taggedfile" or die "$taggedfile does not exist";
while ($line = <FILEEN>){
	chomp($line);
	my $mot=(split(/ /,$line))[0];
	my $tag=(split(/ /,$line))[1];
	if ($line =~ m/^ O/){
		print FILETAG "\n";
	}elsif ($line =~ m/LOC$/){
		my $restloc=substr($line, 0,-4);
		if (exists ($dico_hash_LOC{$restloc})){
			$nblocfound++;
			print FILETAG "<n translation=\"$dico_hash_LOC{$restloc}";
			$e=1;
			while (exists ($dico_hash_LOC{$restloc.$e})){
				print FILETAG "||$dico_hash_LOC{$restloc.$e}";
				$e++;
			}
			print FILETAG "\"> $restloc </n> ";
			
		}else{
			print FILETAG "$restloc ";
		}
	}elsif ($line =~m/PERS$/){
		my $restpers=substr($line, 0,-5);
		if (exists ($dico_hash_names{$restpers})){
			print FILETAG "<n translation=\"$dico_hash_names{$restpers}";
			$nbpersfound++;
			$e=1;
			while (exists ($dico_hash_names{$restpers.$e})){
				print FILETAG "||$dico_hash_names{$restpers.$e}";
				$e++;
			}
			print FILETAG "\"> $restpers </n> ";
		}else{
			print FILETAG "$restpers ";
		}
	}elsif ($line =~ m/ORG$/){
		my $restorg=substr($line, 0,-4);
		if (exists ($dico_hash_org{$restorg})){
			$nborgfound++;
			print FILETAG "<n translation=\"$dico_hash_org{$restorg}";
			$e=1;
			while (exists ($dico_hash_org{$restorg.$e})){
				print FILETAG "||$dico_hash_org{$restorg.$e}";
				$e++;
			}
			print FILETAG "\"> $restorg </n> ";
		}else{
			print FILETAG "$restorg ";
		}		
	}elsif ($tag eq "O"){
		print FILETAG "$mot ";
	}elsif ($line eq ""){
		print FILETAG "\n";
	}else{
		print FILETAG "$mot ";
	}
}
close FILETAG;
close FILEEN;

print "$nblocfound localisations pour lesquelles des traductions sont proposées\n";
print "$nbpersfound personnes pour lesquelles des traductions sont proposées\n";
print "$nborgfound organisations pour lesquelles des traductions sont proposées\n";
