from utils import *
import glob
from build import run_vmd_script
from namd import write_namd_conf

def main():
    mydict = loadyaml('systems.yaml')
    print(mydict)
    # CP Sim toppar dir to top level
    sim_toppar_dir = os.path.abspath(
        mksymlink(
            mydict['Sim_Toppar_Directory'], 'Sim_Toppar_Directory'
        )
    )
    print(sim_toppar_dir)
    build_toppar_dir = os.path.abspath(mydict['Build_Toppar_Directory'])
    build_script = os.path.abspath(mydict['Build_Script'])
    recptor_pdb = os.path.abspath(mydict['Receptor_PDB'])
    vmd_path = os.path.abspath(mydict['VMD_Path'])
    namd_template = os.path.abspath(mydict['NAMD_Template'])
    # Start building systems
    for mysys in mydict['AB_Names']:
        mkdir(mysys)
        chdir(mysys)
        indir = mydict['Directory_Prefix']+mysys
        for pdb in glob.glob(indir+'/Pose*.pdb'):
            pdb_name = pdb.split('/')[-1].split('_%s' % mysys)[0]
            mkdir(pdb_name)
            chdir(pdb_name)
            vmd_arguments = [recptor_pdb, pdb, build_toppar_dir]
            #run_vmd_script(vmd_path, build_script, vmd_arguments)
            rel_sim_toppar_dir = os.path.relpath(sim_toppar_dir)
            write_namd_conf(namd_template, rel_sim_toppar_dir)
            chdir('../')
        chdir('../')


if __name__ == '__main__':
    # Print current working directory
    main()