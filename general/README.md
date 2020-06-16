# General phyloscripts

### **`change_tiplabels.R`**

Changes tiplabels of a tree from TAG notation to individual names. This script can be run as follows:

`change_tiplabels.R input_tree output_tree tag_indiv_df`

where `input_tree` corresponds to the filename of the tree with TAG notation; `output_tree` to the tree with individual notation; `tag_indiv_df` the filename of a table that links TAGs to their individual names.

### **`how_to_run_ete3.sh`**

Short explanation on how to install and run ete3 on a server (without virtual display).

### **`phylo_viz.R`**

Visualization of phylogenetic trees used here in this thesis with **ggtree** and **ape**.

### **`plot_quartetsup_piecharts.R`**

A script from Sidonie Bellot with minor changes. This scripts visualizes quartet support percentages (ASTRAL output) as pie charts on an ASTRAL tree.

### **`root_tree.R`**

Using the **ape** root() function for rooting a tree with the "edgelabel = TRUE" option, to assign the right support value to the right branch. However, due to the ASTRAL format, some formatting was needed with *sed*. The script can be run as follows:

`root_tree.R input_tree output_tree outgroup`

where `input_tree` is the ASTRAL tree (in newick format) that has to be rooted; `output_tree` is the name of the output tree and `outgroup` is the name of the outgroup (!has to be in the input_tree!).