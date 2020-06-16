# -*- coding: utf-8 -*-
###########################################################################
# Project: Orania Phylogeny MT
# Script: add_empty_seqs_for_sp.py
# --- Action: Puts empty sequence for TAGs (individuals)
# ----------- that have no sequence (after alignment)
# ----------- This is necessary for concatenation before dating in BEAST.
# --- Input: alignments
# --- Output: alignments where empty sequences are added for TAGs which do not have alignment
# Author: Maya Schroedl

###########################################################################

#### Packages ####
import os
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import SingleLetterAlphabet
import glob

t = str(2) #t = read coverage threshold

##### DIRECTORIES #############
# Working directory
WD = getcwd() #project working directory

#Create directory "2_phylo_dating/1_alignment"
if not os.path.exists(WD+ "/2_phylo_dating/1_alignment"):
	    os.makedirs(WD+ "/2_phylo_dating/1_alignment")
	    
	    
#directory where alignments are
phylo_dir = WD+"/1_phylo_reconstruction/2_alignment/"+t
os.setdir(phylo_dir)

#get filenames of manually modified alignments (_mod)
#those are the final alignments
matching_filenames = glob.glob("*_mod.fasta") 

#for each alignment: add empty sequences for TAGs where no
for filename in matching_filenames:
    
    #open namelist (list of TAG names)
    with open(WD+"/1_phylo_reconstruction/namelist.txt","r") as totalsp:
        totalsp=totalsp.read().split('\n') #put into table
    
    #read the alignment which corresponds to the gene
    records = list(SeqIO.parse(WD+"/1_phylo_reconstruction/2_alignment/"+t+"/"+
                    filename, "fasta"))
    
    #TAG names of alignments
    recordids=[]
    
    #put names of TAGs which are in alignment to recordids
    for TAG in records:
        recordids.append(TAG.id)
        
    # get difference of the two lists: list of all TAGS and 
                                    #list of TAGs for which there is an alignment
    diff = list(set(totalsp) - set(recordids)) # = which TAGs need an empty sequence added
    
    # create an empty sequence with only "-" which has the length of the alignment
    sequence = Seq("-"*len(records[2].seq),SingleLetterAlphabet) 
    
     # add sequence of "-" for all TAGs which are not represented in this gene alignment
    for TAG in diff:
        newrec = SeqRecord(sequence,id=TAG, description="") #new empty sequence with TAG id
        records.append(newrec)  
    
    # write new alignment (with added empty sequences) to the alignment folder in the dating folder
    SeqIO.write(records, WD+ "/2_phylo_dating/1_alignment/"+filename, "fasta")    
        
