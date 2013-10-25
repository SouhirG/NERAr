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
#########################################################################################
# Description : Translitterate / Convert UTF8 arabic encoding to Buckwalter encoding
#########################################################################################

use Encode;

binmode STDIN, ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';

my $utf8 = shift @ARGV;
my $bw = shift @ARGV;

#my $utf8=$ARGV[0];
#my $bw=$ARGV[1];

#open UTF, "< $utf8" or die "$utf8 does not exist";
open(UTF, "<:encoding(UTF-8)", $utf8) || die("Could not open file: $utf8");
open(BW, ">:encoding(UTF-8)", $bw) || die("Could not open file: $bw");

while ($line = <UTF>){
	
	$line =~ s/\x{0621}/\'/g;   ## HAMZA
	$line =~ s/\x{0622}/\|/g;   ## ALEF WITH MADDA ABOVE
	$line =~ s/\x{0623}/\>/g;   ## ALEF WITH HAMZA ABOVE
	$line =~ s/\x{0624}/\&/g;   ## WAW WITH HAMZA ABOVE
	$line =~ s/\x{0625}/\</g;   ## ALEF WITH HAMZA BELOW
	$line =~ s/\x{0626}/\}/g;   ## YEH WITH HAMZA ABOVE
	$line =~ s/\x{0627}/A/g;    ## ALEF
	$line =~ s/\x{0628}/b/g;    ## BA
	$line =~ s/\x{0629}/p/g;    ## TA MARBUTA
	$line =~ s/\x{062A}/t/g;    ## TA
	$line =~ s/\x{062B}/v/g;    ## THA ث
	$line =~ s/\x{062C}/j/g;    ## JA
	$line =~ s/\x{062D}/H/g;    ## HAH ح
	$line =~ s/\x{062E}/x/g;    ## KHAH خ
	$line =~ s/\x{062F}/d/g;    ## DAL
	$line =~ s/\x{0630}/\*/g;   ## THAL
	$line =~ s/\x{0631}/r/g;    ## RA
	$line =~ s/\x{0632}/z/g;    ## ZAIN
	$line =~ s/\x{0633}/s/g;    ## SEEN
	$line =~ s/\x{0634}/\$/g;   ## SHEEN
	$line =~ s/\x{0635}/S/g;    ## SAD ص
	$line =~ s/\x{0636}/D/g;    ## DAD ض
	$line =~ s/\x{0637}/T/g;    ## TAH ط
	$line =~ s/\x{0638}/Z/g;    ## ZAH
	$line =~ s/\x{0639}/E/g;    ## AIN
	$line =~ s/\x{063A}/g/g;    ## GHAIN
	$line =~ s/\x{0640}//g;    ## TATWEEL
	$line =~ s/\x{0641}/f/g;    ## FA
	$line =~ s/\x{0642}/q/g;    ## QAF
	$line =~ s/\x{0643}/k/g;    ## KAF
	$line =~ s/\x{0644}/l/g;    ## LAM
	$line =~ s/\x{0645}/m/g;    ## MEEM
	$line =~ s/\x{0646}/n/g;    ## NOON
	$line =~ s/\x{0647}/h/g;    ## HA ه
	$line =~ s/\x{0648}/w/g;    ## WAW
	$line =~ s/\x{0649}/Y/g;    ## ALEF MAKSURA
	$line =~ s/\x{064A}/y/g;    ## YA
    ## Ponctuations
	$line =~ s/(\s+)(\,)(\d)/$1SEPPUNCTMARKCOMMA$3/g;
	$line =~ s/(\d+)(\,)(\d)/$1SEPPUNCTMARKCOMMA$3/g;
	$line =~ s/^(\,)(\d)/SEPPUNCTMARKCOMMA$2/g;
	$line =~ s/\x{060C}/,/g;    ## COMMA
	$line =~ s/SEPPUNCTMARKCOMMA/\,/g;
	$line =~ s/\x{037E}/;/g;    ## SEMICOLON
	$line =~ s/\x{061F}/\x{003F}/g;    ## QUESTION MARK
#	$line =~ s/\x{}//g;

    ## Diacritics
	$line =~ s/\x{064B}/F/g;    ## FATHATAN
	$line =~ s/\x{064C}/N/g;    ## DAMMATAN
	$line =~ s/\x{064D}/K/g;    ## KASRATAN
	$line =~ s/\x{064E}/a/g;    ## FATHA
	$line =~ s/\x{064F}/u/g;    ## DAMMA
	$line =~ s/\x{0650}/i/g;    ## KASRA
	$line =~ s/\x{0651}/\~/g;   ## SHADDA
	$line =~ s/\x{0652}/o/g;    ## SUKUN
	$line =~ s/\x{0670}/\`/g;   ## SUPERSCRIPT ALEF

	$line =~ s/\x{0671}/\{/g;   ## ALEF WASLA
	$line =~ s/\x{067E}/P/g;    ## PEH
	$line =~ s/\x{0686}/J/g;    ## TCHEH
	$line =~ s/\x{06A4}/V/g;    ## VEH
	$line =~ s/\x{06AF}/G/g;    ## GAF

    ## Indian characters
	$line =~ s/[\x{06F0}\x{0660}]/0/g;
	$line =~ s/[\x{06F1}\x{0661}]/1/g;
	$line =~ s/[\x{06F2}\x{0662}]/2/g;
	$line =~ s/[\x{06F3}\x{0663}]/3/g;
	$line =~ s/[\x{06F4}\x{0664}]/4/g;
	$line =~ s/[\x{06F5}\x{0665}]/5/g;
	$line =~ s/[\x{06F6}\x{0666}]/6/g;
	$line =~ s/[\x{06F7}\x{0667}]/7/g;
	$line =~ s/[\x{06F8}\x{0668}]/8/g;
	$line =~ s/[\x{06F9}\x{0669}]/9/g;

	print BW "$line";
}

#http://software.hixie.ch/utilities/cgi/unicode-decoder/character-identifier?keywords=arabic
