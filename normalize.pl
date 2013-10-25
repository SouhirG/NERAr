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
# Description : Normalize arabic text as MADA normalization
#		- convert YAA Y to y 
#		- convert ALEF >, <, |, { to A
#		- convert HAMZA &, } to '
#		- convert TAMARBUTA p to h
#######################################################################################################################

my $filetonorm=$ARGV[0];
my @splitline;

binmode STDIN, ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';
binmode STDERR, ':encoding(UTF-8)';

open(TONORM, "<:encoding(UTF-8)", "$filetonorm");# or die "$filetonorm does not exist";
while ($line = <TONORM>){
    @splitline=(split (/\s/,$line));
    $mot=$splitline[0];
    $col1=$splitline[1];
    $col2=$splitline[2];
    $col3=$splitline[3];
    if ($mot eq "#"){
	print "$line";
    }elsif ($mot eq ""){
	print "\n";
    }else{
	$mot =~ s/Y/y/g; 
	$mot =~ s/[><\|A\{]/A/g;
	$mot =~ s/[\&\}]/\'/g;
	$mot =~ s/p/h/g;
	print "$mot $col1\t$col2\t$col3\n";
    }
}
close TONORM
