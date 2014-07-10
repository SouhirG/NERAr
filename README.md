NERAr
====
Named Entity Recognizer for Arabic

Overview
========
This tool preprocess and annonate arabic texts : predict part-of-speech tags, splits off words to separe the basic form and proclitics and annonate arabic named entities. Our tool predict LOC, PERS and ORG entities. Details of this work are presented in: 

Souhir Gahbiche-Braham, Hélène Bonneau-Maynard,  François Yvon. Traitement automatique des entités nommées en arabe : détection et traduction. TAL (Traitement Automatique des Langues), 54(2):101-132, 2014.
[www.atala.org/IMG/pdf/Gahbiche-Braham-TAL54-2.pdf]

If you use NERAr for research purpose, please use the following citation:

    @article{gahbiche2014traitement,
    	title={Traitement automatique des entit{\'e}s nomm{\'e}es en arabe: d{\'e}tection et traduction},		
    	author={Gahbiche-Braham, Souhir and Bonneau-Maynard, H{\'e}l{\`e}ne and Yvon, Fran{\c{c}}ois},
    	journal={TAL},
    	volume={54},
    	number={2},
    	pages={101--132},
    	year={2014}
    }

For any information, bug reports or comments, contact:
	souhir.gahbiche[at]limsi.fr or souhir.gahbiche[at]gmail.com

Requirements
============
To use NERAr:

1- Please install the Wapiti toolkit http://wapiti.limsi.fr/

2- Place the NERAr directory in the Wapiti directory.

3- Unzip the two models modelPOS+SEG-final-0.1.crf.zip and modelsAner+afp+geo-0.2.crf.zip

Run NERAr
========
1- cd ~/wapiti/NERAr

2- ./segment+detect.geo+pretrad.geo.sh arabic_filename

If NERAr cannot run correctly or the loading of model does not succeeds, please unzip the model modelPOS+SEG.light.crf.zip and replace "modelPOS+SEG-final-0.1.crf" by "modelPOS+SEG.light.crf" in the file "segment+detect.geo+pretrad.geo.sh"
 

Resulting files
===============
arabic_filename.norm.pos	contains the part-of-speech tags for each word in the resulting file.result

arabic_filename.bw 		is the transliterated text using Buckwalter scheme.

arabic_filename.wap		contains the predictions for each word in the text
	
arabic_filename.tagsENen	annotated file using IOB annotation

arabic_filename.TOdecode	is a resulting preprocessed file with proposed translations extracted from bilingual dictionaries. This file can be processed with the Moses decoder using exclusive and inclusive options.

arabic_filename.sansbalises	is a resulting preprocessed file without any annotation



