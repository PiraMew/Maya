#!/bin/bash
###########################################################################
# Project: Orania Phylogeny MT
# Script: raxml_script.sh
# --- Action: This script creates gene trees with RaxML
# --- Input: aligned contigs
# --- Output: gene trees
# Author: Maya Schroedl (maya.schroedl@bios.au.dk)

###########################################################################

###################
#----ARGUMENTS----#
###################

#t:if you want trimmed contigs, based on coverage and threshold, 
#   enter t:threshold
#o: outgroup (TAG)
#l: labeled outgroup (individual name)
while getopts ":t:o:l:" opt; do
  case ${opt} in
    t)
      echo "-t was triggered, File: $OPTARG"
      t=$OPTARG
      ;;
o)
      echo "-o was triggered, Outgroup: $OPTARG"
      outgroup=$OPTARG
      ;;
	  
	  l)
      echo "-l was triggered, labeled Outgroup: $OPTARG"
      outgroup_lab=$OPTARG
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
WD="$GWD"/1_phylo_reconstruction #current working directory


#if there is a threshold definded, then work in the threshold directory
if ! [ -z "$t" ];
then
        dir_value=$t/
fi

#make directory
mkdir -p $WD/3_gene_trees/$dir_value
mkdir -p $WD/3_gene_trees/"$dir_value"1_ML #store best maximum likelihood trees
mkdir -p $WD/3_gene_trees/"$dir_value"2_bootstrap #store bootstrap trees
mkdir -p $WD/3_gene_trees/"$dir_value"3_support #store support trees
mkdir -p $WD/3_gene_trees/"$dir_value"4_collapsed #store support trees with collapsed branches


#rm $WD/3_gene_trees/"$dir_value"1_ML/*
#rm $WD/3_gene_trees/"$dir_value"2_bootstrap/*
#rm $WD/3_gene_trees/"$dir_value"3_support/*
#rm $WD/3_gene_trees/"$dir_value"4_collapsed/*


#########################
#----MAKE GENE TREES----#
#########################
# with GTRGAMMA model

cd $WD/3_gene_trees/$dir_value

# #rax1_ML-ng + bootstrap
while read gene;

  #built best maximum likelihood trees
 do raxml-ng --msa $WD/2_alignment/$dir_value"remove"/"$gene"_aligned_gb_mod.fasta 
      --model GTR+G --seed 2 --threads 2 --prefix $WD/3_gene_trees/"$dir_value"1_ML/"$gene" 
      --redo 
      
  #generate bootstraps
 raxml-ng --bootstrap --msa $WD/2_alignment/$dir_value"remove"/"$gene"_aligned_gb_mod.fasta 
      --model GTR+G --seed 2 --bs-trees 200 --threads 2 
      --prefix $WD/3_gene_trees/"$dir_value"2_bootstrap/"$gene" --redo
      
  #from bootstrap trees -> generate one summarized tree with bstrp support for each node
 raxml-ng --support --tree $WD/3_gene_trees/"$dir_value"1_ML/"$gene".raxml.bestTree 
      --bs-trees $WD/3_gene_trees/"$dir_value"2_bootstrap/"$gene".raxml.bootstraps 
      --seed 2 --threads 2 --prefix $WD/3_gene_trees/"$dir_value"3_support/"$gene" 
      --redo
      
done < $WD/genelist_7575.txt

###### collapse branches #########
while read gene;
do 

#collapse all branches with bootstrap <10 #with newick utilities
nw_ed $WD/3_gene_trees/"$dir_value"3_support/"$gene".raxml.support 'i & (b<=10)' 
   o > $WD/3_gene_trees/"$dir_value"4_collapsed/"$gene.raxml.support.bst_coll"; 
   
#collapse all branches with low branchlength (< 0.00001)
Rscript $GWD/scripts/1_phylo_reconstruction/3.1_collapse_low_brnlen.R 
  #input of ML tree (support collapsed)
  $WD/3_gene_trees/"$dir_value"4_collapsed/"$gene.raxml.support.bst_coll" )
  #input of ML tree (support & brnlen collapsed)
  $WD/3_gene_trees/"$dir_value"4_collapsed/"$gene.raxml.support.coll" 
done < $WD/genelist_7575.txt


#combine all RAxML genetrees with support into one file for later use in astral
cat $WD/3_gene_trees/"$dir_value"4_collapsed/*.raxml.support.coll > 
  $WD/3_gene_trees/"$dir_value"4_collapsed/all_genes.raxml.support.coll

cd $GWD

######################
#----LABEL TREES----#
######################

for gene_tree in $WD/3_gene_trees/"$dir_value"4_collapsed/*.raxml.support.coll;
do Rscript $GWD/scripts/general/change_tiplabels.R 
  $gene_tree #input
  $gene_tree"_lab" #output
  $WD/input_reads_and_info/tags_indiv.txt; #list of which TAG label corresponds to which individual
done


######################
#----REROOT TREES----#
######################

#for unlabeled
for gene_tree in $WD/3_gene_trees/"$dir_value"4_collapsed/*.raxml.support.coll; 
do Rscript $GWD/scripts/general/root_tree.R $gene_tree $gene_tree"_rooted" $outgroup;
done 

#for labeled
for gene_tree in $WD/3_gene_trees/"$dir_value"4_collapsed/*.raxml.support.coll_lab; 
do Rscript $GWD/scripts/general/root_tree.R $gene_tree $gene_tree"_rooted" $outgroup_lab;
done 

#combine all rooted RAxML genetrees with support into one file (needed for phypartpiechart)

  #for unlabeled rooted trees
  cat $WD/3_gene_trees/"$dir_value"4_collapsed/*.raxml.support.coll_rooted > 
     $WD/3_gene_trees/"$dir_value"4_collapsed/all_genes.raxml.support.coll_rooted 
     
  #for labeled rooted trees
  cat $WD/3_gene_trees/"$dir_value"4_collapsed/*.raxml.support.coll_lab_rooted > 
     $WD/3_gene_trees/"$dir_value"4_collapsed/all_genes.raxml.support.coll_lab_rooted 

