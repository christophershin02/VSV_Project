### GO INTO THE DIRECTORY YOU WANT TO DO THIS IN. IN THIS CASE YOU WOULD NEED TO RUN THE SCRIPT TWICE, ONCE IN THE 1E9 DIRECTORY AND ONCE IN THE 8G5 DIRECTORY
## Create an epitope.txt file which contains the segid and resid of the given epitope. NAMD is required for this step.

# Creating a function to create a epitope.txt for each pose. 
proc epitope_txt {directory} {

	#Creating a list of all the files in the given directory
	set items [glob -nocomplain -directory $directory *]

	for {set i 0} {$i < [llength $items]} {incr i} {
		puts $i
		cd [lindex $items $i]
		puts "Currently in: [pwd]"

		### Loading in the .psf and .coor files

		mol new complex.psf
		mol addfile pair_int.coor


		set Seltext "name CA and segname A B C and same residue as within 5 of (segname ABH ABL)"
		set Sel [atomselect top $Seltext]
		set Seg_name [$Sel get segname]
		set Res_ID [$Sel get resid]
		### Creating a list of the segment name and residue ID numbers

		set Seg_Res {}
		foreach j $Seg_name k $Res_ID {
			lappend Seg_Res [concat $j$k]
			}
	
		### Putting the list into a .txt file in the associated 
		#Creating the file path
		set file_path "epitope.txt"

		#Open the file in write mode
		set file_handle [open $file_path "w"]

		#Write the contents of Seg_Res into the file
		puts $file_handle $Seg_Res
		close $file_handle
	
		mol delete top


		puts "Finished writing file"

		cd ..

	}
}















