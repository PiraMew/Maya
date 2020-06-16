#!/bin/bash
###########################################################################
# Project: Orania Phylogeny MT
# Script: hashrf.sh
# --- Action: Concatenate the selected gene alignments for dating
# --- Input: selected genes
# --- Output: concatenated alignments
# Author: Maya Schroedl

###########################################################################
#install newest version of https://code.google.com/archive/p/hashrf/downloads

###################
#----ARGUMENTS----#
###################

#t:if you want trimmed contigs, based on coverage and threshold, enter t:threshold

while getopts ":t:" opt; do
    t)
      echo "-t was triggered, Threshold: $OPTARG"
      t=$OPTARG
      ;;

    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac

done


#################################
#----DIRECTORIES & VARIABLES----#
#################################

#working directories
GWD=$PWD #global working directory, with subprojects and scripts
WD="$GWD"/2_phylo_dating #dating directory


mkdir -p $WD/1_alignment/concat
mkdir -p $WD/3_gene_shop/selected_genes

################################
#----CONCATENATE ALIGNMENTS----#
################################

cd $WD/1_alignment/

#### all genes #######

#concatenate all genes a first time
pxcat -s $WD/1_alignment/*_gb_mod.fasta -o $WD/2_alignment/concat/all_genes_concat.fasta 

# 1) Get the individuals with the "best" alignment, in order to have only one 
    #individual per species for dating with the script "get_best_indiv.R"

# 2) manually remove the sequences in the concatenated alignement for the individuals
        #which were not chosen for dating with the script "get_best_indiv.R"


########## select genes ###############

# with script gene_shop_dat.R genes can be selected ("gene shopping") depending on 
      #their gene tree - species tree conflict and whether they are clock-like or not

### concatenate selected genes
concat() {
	filename=$1 #dataset name
	
	#create a file containing a list of filenames (with their directory) which correspond to the alignments
	    # of the genes which were selected for dating
	
	#get list of selecte genes and copy it for modification (add directory before file name; and suffix after)    
	cp $WD/3_gene_shop/selected_genes/$filename.txt $WD/3_gene_shop/selected_genes/"$filename"_files.txt
	
	#add directory before filename
	sed -i -e "s#^#/data_vol/maya/2_phylo_dating/1_alignment/##" $WD/3_gene_shop/selected_genes/"$filename"_files.txt
	
	#add alignment suffix to gene name
	sed -i -e "s/$/_aligned_gb_mod.fasta/" $WD/3_gene_shop/selected_genes/"$filename"_files.txt
	
	#truncate carriage return
	tr -d "\r" < $WD/3_gene_shop/selected_genes/"$filename"_files.txt  >  $filename.txt_ch  && mv  $filename.txt_ch $WD/3_gene_shop/selected_genes/"$filename"_files.txt 

  #put all filenames into one variable for concatenation
	selected_genes_str=$(cat $WD/3_gene_shop/selected_genes/"$filename"_files.txt  | tr "\r" " ")
	
	#see which alignments were chosen (print filenames)
	echo $selected_genes_str
	
	#concatenate selected alignments
	pxcat -s $selected_genes_str -o $WD/1_alignment/concat/"$filename"_concat.fasta
}


rm $WD/1_alignment/concat/*

concat no_gdis #concatenate alignments of the selected genes that had no
                #well-supported nodes (BS > 75%) disagreeing with the species tree
                
concat clock_one #concatenate alignemts of the most "clock-like" gene

####################
#manually remove the sequences in the concatenated alignement for the individuals
        #which were not chosen for dating with the script "get_best_indiv.R" (see above)


