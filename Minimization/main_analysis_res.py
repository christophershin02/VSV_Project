from utils import *
import glob
from build import run_vmd_script
from namd import write_namd_pair_interactions_conf, run_namd


def main():
    mydict = loadyaml('systems.yaml')
    print(mydict)
    pair_int_file_script = os.path.abspath(mydict['VMD_Pair_Int_Script'])
    vmd_path = os.path.abspath(mydict['VMD_Path'])
    namd_path = os.path.abspath(mydict['NAMD_Path'])
    sim_toppar_dir = os.path.abspath('Sim_Toppar_Directory')
    # Write pair interaction file
    grp_1_selection = mydict['Group_1_Selection_Text']
    grp_2_selection = mydict['Group_2_Selection_Text']
    vmd_arguments = ['"' + grp_1_selection + '"', '"' + grp_2_selection + '"']
    print("Starting VMD script")
    run_vmd_script(vmd_path, pair_int_file_script, None)
    namd_template = os.path.abspath(mydict['NAMD_Pair_Interaction_Template'])
    pair_int_pdbs = ['pair_interaction/1E9.pdb', 'pair_interaction/8G5.pdb']
    pair_int_pdbs = [os.path.abspath(pdb) for pdb in pair_int_pdbs]
    # Write NAMD config files
    print("Writing NAMD config files")
    count = 0
    for mysys in mydict['AB_Names']:
        print("Working on system %s" % mysys)
        mkdir(mysys)
        chdir(mysys)
        for pdb in glob.glob('./Pose*'):
            pdb_name = pdb.split('/')[-1].split('_%s' % mysys)[0]
            print("Working on pose %s" % pdb_name)
            chdir(pdb_name)
            rel_sim_toppar_dir = os.path.relpath(sim_toppar_dir)
            rel_pair_int_file = os.path.relpath(pair_int_pdbs[count])
            conf_file = write_namd_pair_interactions_conf(
                namd_template,
                rel_sim_toppar_dir,
                rel_pair_int_file
                )
            print("Running NAMD for pose %s" % pdb_name)
            run_namd(namd_path, conf_file)
            chdir('../')
        chdir('../')
        count += 1



if __name__ == '__main__':
    # Print current working directory
    print(os.getcwd())
    main()
