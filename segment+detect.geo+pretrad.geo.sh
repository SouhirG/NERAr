#!/bin/bash

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
# Description : Arabic Splitter with Wapiti
#               Splits off prefixes : conjunctions w+ and f+, prepositions: b+, k+, l+ (also sub) and future mark: s+
#######################################################################################################################

rep_courant=`pwd`

filetosplit=$1
myscript=$rep_courant


if [[ ${#@} != 1 ]]
then
  echo "Error ($(readlink -f $0)): Wrong number of arguments (${#@})"
  echo "Usage: segment.sh file-to-preprocess"
  exit 1
fi

#translittérer un fichier arabe en buckwalter
echo "Translitteration..."
./convertUTF8toBW.pl $filetosplit $filetosplit.bw


#séparer la ponctuation
echo "Tokenization..."
./separatepunc.pl $filetosplit.bw > $filetosplit.punc

#préparer le fichier d'entrée pour wapiti, un mot par ligne, et chaque phrase est séparée par une ligne vide
echo "Wapiti..."
./format_entree_wapiti.pl $filetosplit.punc > $filetosplit.txt

#étiqueter chaque mot avec un label de la forme pos+pr1+pr2+pr3 en appelant wapiti
cd ..
repp=`pwd`
##model pos+seg

$repp/wapiti label -m $myscript/modelPOS+SEG-final-0.1.crf $filetosplit.txt -p -s > $filetosplit.wap

echo "Normalization..."
cd $rep_courant
#normalize ALEF, YAA, HAMZA, TAMARBUTA
$rep_courant/normalize.pl $filetosplit.wap > $filetosplit.norm

cat $filetosplit.norm | grep -v "^#" > $filetosplit.normOK
echo "Segmentation..."
#segmenter les mots selon les étiquettes qui lui sont attribuées
./split.pl $filetosplit.normOK > $filetosplit.toksp
./split_sanssp.pl $filetosplit.normOK > $filetosplit.tok

#supprimer les espaces en fin de ligne 
./clean_after_split.pl $filetosplit.tok > $filetosplit.seg

cat $filetosplit.normOK | grep -v '^#' | awk '{print $2}' | awk -F'+' '{print $1,$2,$3,$4}' > $filetosplit.pos
cat $filetosplit.normOK | grep -v '^#' | awk '{print $1}' > $filetosplit.mot

paste -d ' ' $filetosplit.seg $filetosplit.pos > $filetosplit.seg.pos

cat $filetosplit.seg.pos  | sed 's/CONJ none/none none/g;s/CONJ PREP/none none/g;s/none PREP/none none/g;s/CONJ SUB/none none/g;s/none SUB/none none/g;s/CONJ FUT/none none/g;s/none FUT/none none/g;s/w+/w+ conj CONJ none none\n/g;s/f+/f+ conj CONJ none none\n/g;s/l+/l+ prep none PREP none\n/g;s/k+/k+ prep none PREP none\n/g;s/b+/b+ prep none PREP none\n/g;s/s+/s+ fut none FUT none\n/g;' > $filetosplit.pos.seg

echo "Named Entities Recognition..."

awk '{print $1}' $filetosplit.pos.seg > $filetosplit.fordico

./annoter_corpus_avec_dico_rapide+geonames.OK+parts_final-norm.pl $filetosplit.fordico $filetosplit.dico $filetosplit.D-Annot
cat $filetosplit.D-Annot | awk '{print $1,$2,$4,$6}' > $filetosplit.dico

paste -d ' ' $filetosplit.dico $filetosplit.pos.seg > $filetosplit.dico+pos
cat $filetosplit.dico+pos | awk '{print $1,$6,$2,$3,$4}' > $filetosplit.pos+dico

$repp/wapiti label -m modelsAner+afp+geo-0.2.crf $filetosplit.pos+dico > $filetosplit.ner

cat $filetosplit.ner | awk '{print $1,$6}' | sed 's/emhtyline/\n/' > $filetosplit.tagsEN
./cherche_dans_dics_all.pl $filetosplit.tagsEN $filetosplit.result

./clean_after_split.pl $filetosplit.result > $filetosplit.TOdecode

cat $filetosplit.TOdecode | sed -e 's/<[^<>]*>//g;s/  */ /g;s/^ //' > $filetosplit.sansbalises

rm 'Dloc'
rm 'Dpers'
rm 'Dorg'
rm $filetosplit.punc
rm $filetosplit.txt
rm $filetosplit.norm
rm $filetosplit.normOK
rm $filetosplit.toksp
rm $filetosplit.pos
rm $filetosplit.normOK.pos
rm $filetosplit.tok
rm $filetosplit.seg
rm $filetosplit.mot
rm $filetosplit.seg.pos
rm $filetosplit.pos.seg
rm $filetosplit.fordico
rm $filetosplit.D-Annot
rm $filetosplit.dico
rm $filetosplit.dico+pos
rm $filetosplit.pos+dico
rm $filetosplit.ner
rm $filetosplit.tagsEN
rm $filetosplit.tagsENout
rm $filetosplit.result
echo "Processing Done"

