#!tcl

##########################################################
#             For the creation of psf files with varying pH
#                   written by John Vant
#                        ASU Biodesign
###########################################################
#                        Notes
# Make sure you are in the directory with mypdb value
# Usage:
#  in bash $ vmd -dispdev text -e build_system.pgn -args <filename>
#  in tkconsole $ source build_system.pgn 

#############################################################
# Set mypdb as the file you want to create a psf for

set receptor_pdb [lindex $argv 0]
set ab_pdb [lindex $argv 1]
set toppar [lindex $argv 2]
#############################################################
# Module load
package require psfgen
resetpsf

##############################################################
# Autopsf topology format
topology $toppar/top_all36_prot.rtf
topology $toppar/top_all36_na.rtf
topology $toppar/top_all36_carb.rtf
topology $toppar/top_all36_lipid.rtf
topology $toppar/top_all36_cgenff.rtf
topology $toppar/top_interface.rtf
topology $toppar/toppar_all36_nano_lig.str
topology $toppar/toppar_all36_nano_lig_patch.str
topology $toppar/toppar_all36_synthetic_polymer.str
topology $toppar/toppar_all36_synthetic_polymer_patch.str
topology $toppar/toppar_all36_polymer_solvent.str
topology $toppar/toppar_water_ions.str
topology $toppar/toppar_dum_noble_gases.str
topology $toppar/toppar_ions_won.str
topology $toppar/cam.str
topology $toppar/toppar_all36_prot_arg0.str
topology $toppar/toppar_all36_prot_c36m_d_aminoacids.str
topology $toppar/toppar_all36_prot_fluoro_alkanes.str
topology $toppar/toppar_all36_prot_heme.str
topology $toppar/toppar_all36_prot_na_combined.str
topology $toppar/toppar_all36_prot_retinol.str
topology $toppar/toppar_all36_prot_model.str
topology $toppar/toppar_all36_prot_modify_res.str
topology $toppar/toppar_all36_na_nad_ppi.str
topology $toppar/toppar_all36_na_rna_modified.str
topology $toppar/toppar_all36_lipid_sphingo.str
topology $toppar/toppar_all36_lipid_archaeal.str
topology $toppar/toppar_all36_lipid_bacterial.str
topology $toppar/toppar_all36_lipid_cardiolipin.str
topology $toppar/toppar_all36_lipid_cholesterol.str
topology $toppar/toppar_all36_lipid_dag.str
topology $toppar/toppar_all36_lipid_inositol.str
topology $toppar/toppar_all36_lipid_lnp.str
topology $toppar/toppar_all36_lipid_lps.str
topology $toppar/toppar_all36_lipid_mycobacterial.str
topology $toppar/toppar_all36_lipid_miscellaneous.str
topology $toppar/toppar_all36_lipid_model.str
topology $toppar/toppar_all36_lipid_prot.str
topology $toppar/toppar_all36_lipid_tag.str
topology $toppar/toppar_all36_lipid_yeast.str
topology $toppar/toppar_all36_lipid_hmmm.str
topology $toppar/toppar_all36_lipid_detergent.str
topology $toppar/toppar_all36_lipid_ether.str
topology $toppar/toppar_all36_carb_glycolipid.str
topology $toppar/toppar_all36_carb_glycopeptide.str
topology $toppar/toppar_all36_carb_imlab.str

##############################################################
# Autopsf parameter format
pdbalias residue HIS HSD
pdbalias residue MSE MET
pdbalias atom ILE CD1 CD
pdbalias residue HOH TIP3

##############################################################
# Get chains and write corresponding pdbs
mol new $receptor_pdb
set selchains [atomselect top "protein"]
set chains [lsort -unique [$selchains get chain]]

foreach i $chains {
    set selchain [atomselect top "chain $i and not water"]
    $selchain writepdb chain$i.pdb
}
# AB chains
mol new $ab_pdb
set selchains [atomselect top "protein"]
set abchains [lsort -unique [$selchains get chain]]

foreach i $abchains {
    set selchain [atomselect top "chain $i and not water"]
    $selchain writepdb abchain$i.pdb
}

##############################################################
# Build segments ie add H to pdb
foreach i $chains {
    segment $i {pdb chain$i.pdb}
}

foreach i $abchains {
    segment "ab$i" {pdb abchain$i.pdb}
}

foreach i $chains {
    coordpdb chain$i.pdb $i
}

foreach i $abchains {
    coordpdb abchain$i.pdb "ab$i"
}
guesscoord

writepdb complex.pdb
writepsf complex.psf

exit