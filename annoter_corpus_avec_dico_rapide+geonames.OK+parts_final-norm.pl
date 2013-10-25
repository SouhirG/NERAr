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
# Description : Annonate corpora using monolingual dictionaries
#######################################################################################################################

my $dico_LOC="dics/dico-mono-LOC.norm";
my $dico_NAMES="dics/dico-mono-PERS.norm";
my $dico_OrgGazetteer="dics/dico-mono-ORG.norm";

my $corpus_a_annoter=$ARGV[$0];
my $corpus_annote=$ARGV[$1];
my $all_annot=$ARGV[2];
my $corpus_annote_loc="Dloc";
my $corpus_annote_org="Dorg";
my $corpus_annote_pers="Dpers";

my (%dico_hash_LocGaz, %dico_hash_PersGaz, %dico_hash_OrgGaz, %dico_hash_names, %dico_hash_wnoms, %dico_hash_wpays, %dico_hash_wpers, %dico_hash_wprenoms, %dico_hash_wregions, %dico_hash_LOC, %dico_hash_geonames); 
my $line;

my @file_src=();

open DICO_LOCs, "< $dico_LOC" or die "$dico_LOC does not exist";
while ($line = <DICO_LOCs>){
    $line=~s/\n//;
    if (!exists $dico_hash_LOC{$line}){
	$dico_hash_LOC{$line}=1;
    }
}
close DICO_LOCs;

open DICO_OrgGaz, "< $dico_OrgGazetteer" or die "$dico_OrgGazetteer does not exist";
while ($line = <DICO_OrgGaz>){
    $line=~s/\n//;
    if (!exists $dico_hash_OrgGaz{$line}){
	$dico_hash_OrgGaz{$line}=1;
    }
}
close DICO_OrgGaz;

open DICO_names, "< $dico_NAMES" or die "$dico_NAMES does not exist";
while ($line = <DICO_names>){
    $line=~s/\n//;
    if (!exists $dico_hash_names{$line}){
	$dico_hash_names{$line}=1;
    }
}
close DICO_names;

open DICO_LOCs, "< $dico_LOC" or die "$dico_LOC does not exist";
while ($line = <DICO_LOCs>){
    $line=~s/\n//;
    $tailleenlocs=(split(/ /,$line));
    @motsenlocs=(split(/ /,$line));
    $tloc=0;
    while ($tloc < $tailleenlocs){
	if (!exists $dico_hash_LOC_ind{$motsenlocs[$tloc]}){
		$dico_hash_LOC_ind{$motsenlocs[$tloc]}=1;
    	}
	$tloc++;
    }
}
close DICO_LOCs;

open DICO_OrgGaz, "< $dico_OrgGazetteer" or die "$dico_OrgGazetteer does not exist";
while ($line = <DICO_OrgGaz>){
    $line=~s/\n//;
    $tailleenorgs=(split(/ /,$line));
    @motsenorgs=(split(/ /,$line));
    $torg=0;
    while ($torg < $tailleenorgs){
	if (!exists $dico_hash_OrgGaz_ind{$motsenorgs[$torg]}){
		$dico_hash_OrgGaz_ind{$motsenorgs[$torg]}=1;
    	}
	$torg++;
    }
}
close DICO_OrgGaz;

open DICO_names, "< $dico_NAMES" or die "$dico_NAMES does not exist";
while ($line = <DICO_names>){
    $line=~s/\n//;
    $tailleennames=(split(/ /,$line));
    @motsennames=(split(/ /,$line));
    $tpers=0;
    while ($tpers < $tailleennames){
	if (!exists $dico_hash_names_ind{$motsennames[$tpers]}){
		$dico_hash_names_ind{$motsennames[$tpers]}=1;
    	}
	$tpers++;
    }
}
close DICO_names;



my $i=0;
my $len;
my $c1="";
my $c2="";

my $m=0;

open FICH_SRC, "<:encoding(UTF-8)", "$corpus_a_annoter" or die "$corpus_a_annoter";
while ($line = <FICH_SRC>){
	$mot=(split(/ /,$line))[0];
	chomp($mot);
	$file_src[$m]=$mot;
	$m++;
}
close FICH_SRC;
$taille = @file_src;


open FILE_DST_LOC, ">:encoding(UTF-8)", "$corpus_annote_loc" or die "$corpus_annote_loc";
open FILE_DST_ORG, ">:encoding(UTF-8)", "$corpus_annote_org" or die "$corpus_annote_org";
open FILE_DST_PERS, ">:encoding(UTF-8)", "$corpus_annote_pers" or die "$corpus_annote_pers";
$i=0;$j=0;$k=0;
foreach $x (@file_src){
	$EN_de_deux=$file_src[$i]." ".$file_src[$i+1];
	$EN_de_trois=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2];
	$EN_de_quatre=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3];
	$EN_de_cinq=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4];
	$EN_de_six=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5];
	$EN_de_sept=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6];
	$EN_de_huit=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7];
	$EN_de_neuf=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8];
	$EN_de_dix=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8]." ".$file_src[$i+9];
	$EN_de_onze=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8]." ".$file_src[$i+9]." ".$file_src[$i+10];
	$EN_de_douze=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8]." ".$file_src[$i+9]." ".$file_src[$i+10]." ".$file_src[$i+11];
	$EN_de_treize=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8]." ".$file_src[$i+9]." ".$file_src[$i+10]." ".$file_src[$i+11]." ".$file_src[$i+12];
	my $c1m1=substr($file_src[$i], 1);
	my $c1m2=substr($EN_de_deux, 1);
	my $c1m3=substr($EN_de_tois, 1);
	my $c1m4=substr($EN_de_quatre, 1);
	my $c1m5=substr($EN_de_cinq, 1);
	my $c1m6=substr($EN_de_six, 1);
        my $c1m7=substr($EN_de_sept, 1);
        my $c1m8=substr($EN_de_huit, 1);
        my $c1m9=substr($EN_de_neuf, 1);
        my $c1m10=substr($EN_de_dix, 1);
        my $c1m11=substr($EN_de_onze, 1);
	my $c1m12=substr($EN_de_douze, 1);
	my $c1m13=substr($EN_de_treize, 1);
	
        my $c2m1=substr($file_src[$i], 2);
        my $c2m2=substr($EN_de_deux, 2);
        my $c2m3=substr($EN_de_tois, 2);
        my $c2m4=substr($EN_de_quatre, 2);
        my $c2m5=substr($EN_de_cinq, 2);
        my $c2m6=substr($EN_de_six, 2);
        my $c2m7=substr($EN_de_sept, 2);
        my $c2m8=substr($EN_de_huit, 2);
        my $c2m9=substr($EN_de_neuf, 2);
        my $c2m10=substr($EN_de_dix, 2);
        my $c2m11=substr($EN_de_onze, 2);
	my $c2m12=substr($EN_de_douze, 2);
	my $c2m13=substr($EN_de_treize, 2);
	
	while ($i < $taille){
		$EN_de_deux=$file_src[$i]." ".$file_src[$i+1];
		$EN_de_trois=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2];
		$EN_de_quatre=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3];
		$EN_de_cinq=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4];
		$EN_de_six=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5];
		$EN_de_sept=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6];
		$EN_de_huit=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7];
		$EN_de_neuf=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8];
		$EN_de_dix=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8]." ".$file_src[$i+9];
		$EN_de_onze=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8]." ".$file_src[$i+9]." ".$file_src[$i+10];
		$EN_de_douze=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8]." ".$file_src[$i+9]." ".$file_src[$i+10]." ".$file_src[$i+11];
		$EN_de_treize=$file_src[$i]." ".$file_src[$i+1]." ".$file_src[$i+2]." ".$file_src[$i+3]." ".$file_src[$i+4]." ".$file_src[$i+5]." ".$file_src[$i+6]." ".$file_src[$i+7]." ".$file_src[$i+8]." ".$file_src[$i+9]." ".$file_src[$i+10]." ".$file_src[$i+11]." ".$file_src[$i+12];
		my $c1m1=substr($file_src[$i], 1);
		my $c1m2=substr($EN_de_deux, 1);
		my $c1m3=substr($EN_de_tois, 1);
		my $c1m4=substr($EN_de_quatre, 1);
		my $c1m5=substr($EN_de_cinq, 1);
		my $c1m6=substr($EN_de_six, 1);
        	my $c1m7=substr($EN_de_sept, 1);
       	 	my $c1m8=substr($EN_de_huit, 1);
        	my $c1m9=substr($EN_de_neuf, 1);
       	 	my $c1m10=substr($EN_de_dix, 1);
        	my $c1m11=substr($EN_de_onze, 1);
		my $c1m12=substr($EN_de_douze, 1);
		my $c1m13=substr($EN_de_treize, 1);
	
       	 	my $c2m1=substr($file_src[$i], 2);
	        my $c2m2=substr($EN_de_deux, 2);
	        my $c2m3=substr($EN_de_tois, 2);
        	my $c2m4=substr($EN_de_quatre, 2);
        	my $c2m5=substr($EN_de_cinq, 2);
        	my $c2m6=substr($EN_de_six, 2);
        	my $c2m7=substr($EN_de_sept, 2);
        	my $c2m8=substr($EN_de_huit, 2);
        	my $c2m9=substr($EN_de_neuf, 2);
        	my $c2m10=substr($EN_de_dix, 2);
        	my $c2m11=substr($EN_de_onze, 2);
		my $c2m12=substr($EN_de_douze, 2);
		my $c2m13=substr($EN_de_treize, 2);
	
		if ($file_src[$i] eq "" ){
			print FILE_DST_LOC "\n";$i++;
		}elsif (exists $dico_hash_LOC{$file_src[$i]}){
			print FILE_DST_LOC "$file_src[$i] DB-L-Exact\n";$i++;
		}elsif (exists $dico_hash_LOC{$EN_de_deux}){
			print FILE_DST_LOC "$file_src[$i] DB-L-Exact\n$file_src[$i+1] DI-L-Exact\n";$i=$i+2;
		}elsif (exists $dico_hash_LOC{$EN_de_trois}){
			print FILE_DST_LOC "$file_src[$i] DB-L-Exact\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n";$i=$i+3;
		}elsif (exists $dico_hash_LOC{$EN_de_quatre}){
			print FILE_DST_LOC "$file_src[$i] DB-L-Exact\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n$file_src[$i+3] DI-L-Exact\n";$i=$i+4;
		}elsif (exists $dico_hash_LOC{$EN_de_cinq}){
			print FILE_DST_LOC "$file_src[$i] DB-L-Exact\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n$file_src[$i+3] DI-L-Exact\n$file_src[$i+4] DI-L-Exact\n";$i=$i+5;
		}elsif (exists $dico_hash_LOC{$EN_de_six}){
			print FILE_DST_LOC "$file_src[$i] DB-L-Exact\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n$file_src[$i+3] DI-L-Exact\n$file_src[$i+4] DI-L-Exact\n$file_src[$i+5] DI-L-Exact\n";$i=$i+6;
		}elsif (exists $dico_hash_LOC{$c1m1}){
			print FILE_DST_LOC "$file_src[$i] DB-L+1c\n";$i++;
		}elsif (exists $dico_hash_LOC{$c1m2}){
			print FILE_DST_LOC "$file_src[$i] DB-L+1c\n$file_src[$i+1] DI-L-Exact\n";$i=$i+2;
		}elsif (exists $dico_hash_LOC{$c1m3}){
			print FILE_DST_LOC "$file_src[$i] DB-L+1c\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n";$i=$i+3;
		}elsif (exists $dico_hash_LOC{$c1m4}){
			print FILE_DST_LOC "$file_src[$i] DB-L+1c\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n$file_src[$i+3] DI-L-Exact\n";$i=$i+4;
		}elsif (exists $dico_hash_LOC{$c1m5}){
			print FILE_DST_LOC "$file_src[$i] DB-L+1c\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n$file_src[$i+3] DI-L-Exact\n$file_src[$i+4] DI-L-Exact\n";$i=$i+5;
		}elsif (exists $dico_hash_LOC{$c1m6}){
			print FILE_DST_LOC "$file_src[$i] DB-L+1c\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n$file_src[$i+3] DI-L-Exact\n$file_src[$i+4] DI-L-Exact\n$file_src[$i+5] DI-L-Exact\n";$i=$i+6;
		}elsif (exists $dico_hash_LOC{$c2m1}){
			print FILE_DST_LOC "$file_src[$i] DB-L+2c\n";$i++;
		}elsif (exists $dico_hash_LOC{$c2m2}){
			print FILE_DST_LOC "$file_src[$i] DB-L+2c\n$file_src[$i+1] DI-L-Exact\n";$i=$i+2;
		}elsif (exists $dico_hash_LOC{$c2m3}){
			print FILE_DST_LOC "$file_src[$i] DB-L+2c\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n";$i=$i+3;
		}elsif (exists $dico_hash_LOC{$c2m4}){
			print FILE_DST_LOC "$file_src[$i] DB-L+2c\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n$file_src[$i+3] DI-L-Exact\n";$i=$i+4;
		}elsif (exists $dico_hash_LOC{$c2m5}){
			print FILE_DST_LOC "$file_src[$i] DB-L+2c\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n$file_src[$i+3] DI-L-Exact\n$file_src[$i+4] DI-L-Exact\n";$i=$i+5;
		}elsif (exists $dico_hash_LOC{$c2m6}){
			print FILE_DST_LOC "$file_src[$i] DB-L+2c\n$file_src[$i+1] DI-L-Exact\n$file_src[$i+2] DI-L-Exact\n$file_src[$i+3] DI-L-Exact\n$file_src[$i+4] DI-L-Exact\n$file_src[$i+5] DI-L-Exact\n";$i=$i+6;
		}else{
			print FILE_DST_LOC "$file_src[$i] OL\n";$i++;
		}
	}
	
	while ($j < $taille){
		$EN_de_deux=$file_src[$j]." ".$file_src[$j+1];
		$EN_de_trois=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2];
		$EN_de_quatre=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3];
		$EN_de_cinq=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3]." ".$file_src[$j+4];
		$EN_de_six=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3]." ".$file_src[$j+4]." ".$file_src[$j+5];
		$EN_de_sept=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3]." ".$file_src[$j+4]." ".$file_src[$j+5]." ".$file_src[$j+6];
		$EN_de_huit=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3]." ".$file_src[$j+4]." ".$file_src[$j+5]." ".$file_src[$j+6]." ".$file_src[$j+7];
		$EN_de_neuf=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3]." ".$file_src[$j+4]." ".$file_src[$j+5]." ".$file_src[$j+6]." ".$file_src[$j+7]." ".$file_src[$j+8];
		$EN_de_dix=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3]." ".$file_src[$j+4]." ".$file_src[$j+5]." ".$file_src[$j+6]." ".$file_src[$j+7]." ".$file_src[$j+8]." ".$file_src[$j+9];
		$EN_de_onze=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3]." ".$file_src[$j+4]." ".$file_src[$j+5]." ".$file_src[$j+6]." ".$file_src[$j+7]." ".$file_src[$j+8]." ".$file_src[$j+9]." ".$file_src[$j+10];
		$EN_de_douze=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3]." ".$file_src[$j+4]." ".$file_src[$j+5]." ".$file_src[$j+6]." ".$file_src[$j+7]." ".$file_src[$j+8]." ".$file_src[$j+9]." ".$file_src[$j+10]." ".$file_src[$j+11];
		$EN_de_treize=$file_src[$j]." ".$file_src[$j+1]." ".$file_src[$j+2]." ".$file_src[$j+3]." ".$file_src[$j+4]." ".$file_src[$j+5]." ".$file_src[$j+6]." ".$file_src[$j+7]." ".$file_src[$j+8]." ".$file_src[$j+9]." ".$file_src[$j+10]." ".$file_src[$j+11]." ".$file_src[$j+12];
		my $c1m1=substr($file_src[$j], 1);
		my $c1m2=substr($EN_de_deux, 1);
		my $c1m3=substr($EN_de_tois, 1);
		my $c1m4=substr($EN_de_quatre, 1);
		my $c1m5=substr($EN_de_cinq, 1);
		my $c1m6=substr($EN_de_six, 1);
        	my $c1m7=substr($EN_de_sept, 1);
        	my $c1m8=substr($EN_de_huit, 1);
        	my $c1m9=substr($EN_de_neuf, 1);
        	my $c1m10=substr($EN_de_dix, 1);
        	my $c1m11=substr($EN_de_onze, 1);
		my $c1m12=substr($EN_de_douze, 1);
		my $c1m13=substr($EN_de_treize, 1);
	
        	my $c2m1=substr($file_src[$j], 2);
        	my $c2m2=substr($EN_de_deux, 2);
        	my $c2m3=substr($EN_de_tois, 2);
        	my $c2m4=substr($EN_de_quatre, 2);
        	my $c2m5=substr($EN_de_cinq, 2);
        	my $c2m6=substr($EN_de_six, 2);
        	my $c2m7=substr($EN_de_sept, 2);
        	my $c2m8=substr($EN_de_huit, 2);
        	my $c2m9=substr($EN_de_neuf, 2);
        	my $c2m10=substr($EN_de_dix, 2);
        	my $c2m11=substr($EN_de_onze, 2);
		my $c2m12=substr($EN_de_douze, 2);
		my $c2m13=substr($EN_de_treize, 2);
	
		if ($file_src[$j] eq "" ){
			print FILE_DST_ORG "\n";$j++;
		}elsif (exists $dico_hash_OrgGaz{$file_src[$j]}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG-Exact\n";$j++;
		}elsif (exists $dico_hash_OrgGaz{$EN_de_deux}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG-Exact\n$file_src[$j+1] DI-ORG-Exact\n";$j=$j+2;
		}elsif (exists $dico_hash_OrgGaz{$EN_de_trois}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG-Exact\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n";$j=$j+3;
		}elsif (exists $dico_hash_OrgGaz{$EN_de_quatre}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG-Exact\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j+3] DI-ORG-Exact\n";$j=$j+4;
		}elsif (exists $dico_hash_OrgGaz{$EN_de_cinq}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG-Exact\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j	+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n";$j=$j+5;
		}elsif (exists $dico_hash_OrgGaz{$EN_de_six}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG-Exact\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j	+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n$file_src[$j+5] DI-ORG-Exact\n";$j=$j+6;
		}elsif (exists $dico_hash_OrgGaz{$EN_de_sept}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG-Exact\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n$file_src[$j+5] DI-ORG-Exact\n$file_src[$j+6] DI-ORG-Exact\n";$j=$j+7;
		}elsif (exists $dico_hash_OrgGaz{$EN_de_huit}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG-Exact\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n$file_src[$j+5] DI-ORG-Exact\n$file_src[$j+6] DI-ORG-Exact\n$file_src[$j+7] DI-ORG-Exact\n";$j=$j+8;
		}elsif (exists $dico_hash_OrgGaz{$c1m1}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+1c\n";$j++;
		}elsif (exists $dico_hash_OrgGaz{$c1m2}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+1c\n$file_src[$j+1] DI-ORG-Exact\n";$j=$j+2;
		}elsif (exists $dico_hash_OrgGaz{$c1m3}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+1c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n";$j=$j+3;
		}elsif (exists $dico_hash_OrgGaz{$c1m4}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+1c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j+3] DI-ORG-Exact\n";$j=$j+4;
		}elsif (exists $dico_hash_OrgGaz{$c1m5}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+1c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j	+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n";$j=$j+5;
		}elsif (exists $dico_hash_OrgGaz{$c1m6}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+1c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j	+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n$file_src[$j+5] DI-ORG-Exact\n";$j=$j+6;
		}elsif (exists $dico_hash_OrgGaz{$c1m7}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+1c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n$file_src[$j+5] DI-ORG-Exact\n$file_src[$j+6] DI-ORG-Exact\n";$j=$j+7;
		}elsif (exists $dico_hash_OrgGaz{$c1m8}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+1c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n$file_src[$j+5] DI-ORG-Exact\n$file_src[$j+6] DI-ORG-Exact\n$file_src[$j+7] DI-ORG-Exact\n";$j=$j+8;
		}elsif (exists $dico_hash_OrgGaz{$c2m1}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+2c\n";$j++;
		}elsif (exists $dico_hash_OrgGaz{$c2m2}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+2c\n$file_src[$j+1] DI-ORG-Exact\n";$j=$j+2;
		}elsif (exists $dico_hash_OrgGaz{$c2m3}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+2c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n";$j=$j+3;
		}elsif (exists $dico_hash_OrgGaz{$c2m4}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+2c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j+3] DI-ORG-Exact\n";$j=$j+4;
		}elsif (exists $dico_hash_OrgGaz{$c2m5}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+2c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j	+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n";$j=$j+5;
		}elsif (exists $dico_hash_OrgGaz{$c2m6}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+2c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j	+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n$file_src[$j+5] DI-ORG-Exact\n";$j=$j+6;
		}elsif (exists $dico_hash_OrgGaz{$c2m7}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+2c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n$file_src[$j+5] DI-ORG-Exact\n$file_src[$j+6] DI-ORG-Exact\n";$j=$j+7;
		}elsif (exists $dico_hash_OrgGaz{$c2m8}){
			print FILE_DST_ORG "$file_src[$j] DB-ORG+2c\n$file_src[$j+1] DI-ORG-Exact\n$file_src[$j+2] DI-ORG-Exact\n$file_src[$j+3] DI-ORG-Exact\n$file_src[$j+4] DI-ORG-Exact\n$file_src[$j+5] DI-ORG-Exact\n$file_src[$j+6] DI-ORG-Exact\n$file_src[$j+7] DI-ORG-Exact\n";$j=$j+8;
		}else{
			print FILE_DST_ORG "$file_src[$j] OO\n";
			$j++;
		}
	}

	while ($k < $taille){
		$EN_de_deux=$file_src[$k]." ".$file_src[$k+1];
		$EN_de_trois=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2];
		$EN_de_quatre=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3];
		$EN_de_cinq=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3]." ".$file_src[$k+4];
		$EN_de_six=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3]." ".$file_src[$k+4]." ".$file_src[$k+5];
		$EN_de_sept=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3]." ".$file_src[$k+4]." ".$file_src[$k+5]." ".$file_src[$k+6];
		$EN_de_huit=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3]." ".$file_src[$k+4]." ".$file_src[$k+5]." ".$file_src[$k+6]." ".$file_src[$k+7];
		$EN_de_neuf=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3]." ".$file_src[$k+4]." ".$file_src[$k+5]." ".$file_src[$k+6]." ".$file_src[$k+7]." ".$file_src[$k+8];
		$EN_de_dix=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3]." ".$file_src[$k+4]." ".$file_src[$k+5]." ".$file_src[$k+6]." ".$file_src[$k+7]." ".$file_src[$k+8]." ".$file_src[$k+9];
		$EN_de_onze=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3]." ".$file_src[$k+4]." ".$file_src[$k+5]." ".$file_src[$k+6]." ".$file_src[$k+7]." ".$file_src[$k+8]." ".$file_src[$k+9]." ".$file_src[$k+10];
		$EN_de_douze=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3]." ".$file_src[$k+4]." ".$file_src[$k+5]." ".$file_src[$k+6]." ".$file_src[$k+7]." ".$file_src[$k+8]." ".$file_src[$k+9]." ".$file_src[$k+10]." ".$file_src[$k+11];
		$EN_de_treize=$file_src[$k]." ".$file_src[$k+1]." ".$file_src[$k+2]." ".$file_src[$k+3]." ".$file_src[$k+4]." ".$file_src[$k+5]." ".$file_src[$k+6]." ".$file_src[$k+7]." ".$file_src[$k+8]." ".$file_src[$k+9]." ".$file_src[$k+10]." ".$file_src[$k+11]." ".$file_src[$k+12];
		my $c1m1=substr($file_src[$k], 1);
		my $c1m2=substr($EN_de_deux, 1);
		my $c1m3=substr($EN_de_tois, 1);
		my $c1m4=substr($EN_de_quatre, 1);
		my $c1m5=substr($EN_de_cinq, 1);
		my $c1m6=substr($EN_de_six, 1);
        	my $c1m7=substr($EN_de_sept, 1);
        	my $c1m8=substr($EN_de_huit, 1);
        	my $c1m9=substr($EN_de_neuf, 1);
        	my $c1m10=substr($EN_de_dix, 1);
        	my $c1m11=substr($EN_de_onze, 1);
		my $c1m12=substr($EN_de_douze, 1);
		my $c1m13=substr($EN_de_treize, 1);
		
        	my $c2m1=substr($file_src[$k], 2);
        	my $c2m2=substr($EN_de_deux, 2);
        	my $c2m3=substr($EN_de_tois, 2);
        	my $c2m4=substr($EN_de_quatre, 2);
        	my $c2m5=substr($EN_de_cinq, 2);
        	my $c2m6=substr($EN_de_six, 2);
        	my $c2m7=substr($EN_de_sept, 2);
        	my $c2m8=substr($EN_de_huit, 2);
        	my $c2m9=substr($EN_de_neuf, 2);
        	my $c2m10=substr($EN_de_dix, 2);
        	my $c2m11=substr($EN_de_onze, 2);
		my $c2m12=substr($EN_de_douze, 2);
		my $c2m13=substr($EN_de_treize, 2);
	if ($file_src[$k] eq "" ){
			print FILE_DST_PERS "\n";$k++;
		}elsif (exists $dico_hash_names{$file_src[$k]}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n";$k++;
		}elsif (exists $dico_hash_names{$EN_de_deux}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n";$k=$k+2;
		}elsif (exists $dico_hash_names{$EN_de_trois}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n";$k=$k+3;
		}elsif (exists $dico_hash_names{$EN_de_quatre}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n";$k=$k+4;
		}elsif (exists $dico_hash_names{$EN_de_cinq}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n";$k=$k+5;
		}elsif (exists $dico_hash_names{$EN_de_six}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n";$k=$k+6;
		}elsif (exists $dico_hash_names{$EN_de_sept}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n";$k=$k+7;
		}elsif (exists $dico_hash_names{$EN_de_huit}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n";$k=$k+8;
		}elsif (exists $dico_hash_names{$EN_de_neuf}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n";$k=$k+9;
		}elsif (exists $dico_hash_names{$EN_de_dix}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n";$k=$k+10;
		}elsif (exists $dico_hash_names{$EN_de_onze}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n$file_src[$k+10] DI-P-Exact\n";$k=$k+11;
		}elsif (exists $dico_hash_names{$EN_de_douze}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n$file_src[$k+10] DI-P-Exact\n$file_src[$k+11] DI-P-Exact\n";$k=$k+12;
		}elsif (exists $dico_hash_names{$EN_de_treize}){
			print FILE_DST_PERS "$file_src[$k] DB-P-Exact\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n$file_src[$k+10] DI-P-Exact\n$file_src[$k+11] DI-P-Exact\n$file_src[$k+12] DI-P-Exact\n";$k=$k+13;
		}elsif (exists $dico_hash_names{$c1m1}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n";$k++;
		}elsif (exists $dico_hash_names{$c1m2}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n";$k=$k+2;
		}elsif (exists $dico_hash_names{$c1m3}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n";$k=$k+3;
		}elsif (exists $dico_hash_names{$c1m4}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n";$k=$k+4;
		}elsif (exists $dico_hash_names{$c1m5}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n";$k=$k+5;
		}elsif (exists $dico_hash_names{$c1m6}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n";$k=$k+6;
		}elsif (exists $dico_hash_names{$c1m7}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n";$k=$k+7;
		}elsif (exists $dico_hash_names{$c1m8}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n";$k=$k+8;
		}elsif (exists $dico_hash_names{$c1m9}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n";$k=$k+9;
		}elsif (exists $dico_hash_names{$c1m10}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n";$k=$k+10;
		}elsif (exists $dico_hash_names{$c1m11}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n$file_src[$k+10] DI-P-Exact\n";$k=$k+11;
		}elsif (exists $dico_hash_names{$c1m12}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n$file_src[$k+10] DI-P-Exact\n$file_src[$k+11] DI-P-Exact\n";$k=$k+12;
		}elsif (exists $dico_hash_names{$c1m13}){
			print FILE_DST_PERS "$file_src[$k] DB-P+1c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n$file_src[$k+10] DI-P-Exact\n$file_src[$k+11] DI-P-Exact\n$file_src[$k+12] DI-P-Exact\n";$k=$k+13;
		}elsif (exists $dico_hash_names{$c2m1}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n";$k++;
		}elsif (exists $dico_hash_names{$c2m2}){
			if ($file_src[$k+1] eq ""){
				print  FILE_DST_PERS "$file_src[$k] DB-P+2c\n"; $k=$k+1;
			}else{
				print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n";$k=$k+2;
			}
		}elsif (exists $dico_hash_names{$c2m3}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n";$k=$k+3;
		}elsif (exists $dico_hash_names{$c2m4}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n";$k=$k+4;
		}elsif (exists $dico_hash_names{$c2m5}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n";$k=$k+5;
		}elsif (exists $dico_hash_names{$c2m6}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n";$k=$k+6;
		}elsif (exists $dico_hash_names{$c2m7}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n";$k=$k+7;
		}elsif (exists $dico_hash_names{$c2m8}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n";$k=$k+8;
		}elsif (exists $dico_hash_names{$c2m9}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n";$k=$k+9;
		}elsif (exists $dico_hash_names{$c2m10}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n";$k=$k+10;
		}elsif (exists $dico_hash_names{$c2m11}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n$file_src[$k+10] DI-P-Exact\n";$k=$k+11;
		}elsif (exists $dico_hash_names{$c2m12}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n$file_src[$k+10] DI-P-Exact\n$file_src[$k+11] DI-P-Exact\n";$k=$k+12;
		}elsif (exists $dico_hash_names{$c2m13}){
			print FILE_DST_PERS "$file_src[$k] DB-P+2c\n$file_src[$k+1] DI-P-Exact\n$file_src[$k+2] DI-P-Exact\n$file_src[$k+3] DI-P-Exact\n$file_src[$k+4] DI-P-Exact\n$file_src[$k+5] DI-P-Exact\n$file_src[$k+6] DI-P-Exact\n$file_src[$k+7] DI-P-Exact\n$file_src[$k+8] DI-P-Exact\n$file_src[$k+9] DI-P-Exact\n$file_src[$k+10] DI-P-Exact\n$file_src[$k+11] DI-P-Exact\n$file_src[$k+12] DI-P-Exact\n";$k=$k+13;
		}else{
			print FILE_DST_PERS "$file_src[$k] OP\n";$k++;
		}
	}
}

close FILE_DST_LOC;
close FILE_DST_ORG;
close FILE_DST_PERS;

system (" paste -d ' ' '$corpus_annote_loc' '$corpus_annote_org' '$corpus_annote_pers' > '$all_annot' ");



