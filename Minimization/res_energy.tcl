puts "Hello from VMD"
puts $argv
set group1_selection_text "protein and segname A B C"
set group2_selection_text "protein and segname ABH ABL"

file mkdir pair_interaction
foreach system {1E9 8G5} pose {Pose1_Cluster2 Pose1_Cluster15} {
    set indir ./$system/$pose
    mol new $indir/complex.psf
    mol addfile $indir/complex.pdb

    set selall [atomselect top all]
    $selall set beta 0
    set selgroup1 [atomselect top $group1_selection_text]
    $selgroup1 set beta 1
    set selgroup2 [atomselect top $group2_selection_text]
    $selgroup2 set beta 2

    # write out pdb
    $selall writepdb pair_interaction/$system.pdb
}

exit
