# Ancestral range estimation


### **`biogeobears_without_node_constr.R`**

Ancestral range estimation with the R package [**BioGeoBEARS**](http://phylo.wikidot.com/biogeobears) v.1.1.2. This script is based on the [example script](http://phylo.wikidot.com/biogeobears#script) of **BioGeoBEARS**. The outgroup was excluded from this analysis

Please see the **BioGeoBEARS** website for documentation.

All three available range evolution models (DIVA, DIVALIKE, BAYAREALIKE) were applied, without the jump dispersal parameter (+J). For each range evolution model, three dispersal probability models were tested:

* M0: without any dispersal constraint. all dispersal probabilites are equal
* MF: dispersal probability matrices adapted from Federman et al. (2015)
* MB: dispersal probability matrices adapted from Baker and Couvreur (2013)

These nine models were compared with the AICc.


### **`biogeobears_node_constr.R`**

This script is the same as `biogeobears_without_node_constr.R`, except that the outgroup was included and the basal node was constraint to the area "SE" (i.e. Southeast Asia and Eurasia) based on Baker (2013).

### Bibliography

Baker, W.J. & Couvreur, T.L.P. 2013. Global biogeography and diversification
of palms sheds light on the evolution of tropical lineages. I. Historical
biogeography. Journal of Biogeography, 40(2): 274--285. doi:10.1111/j.1365-
2699.2012.02795.x

Federman, S., Dornburg, A., Downie, A., Richard, A.F., Daly, D.C., &
Donoghue, M.J. 2015. The biogeographic origin of a radiation of trees in Madagascar:
Implications for the assembly of a tropical forest biome. BMC Evolutionary
Biology, 15(1): 216. doi:10.1186/s12862-015-0483-1.