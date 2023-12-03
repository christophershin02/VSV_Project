import os

def run_vmd_script(vmd_path, script, arg_list):
    if arg_list is not None:
        args = ' '.join(arg_list)
        print("My args are: %s" % args)
        vmd_line = '%s -dispdev text -args %s -e %s' % (vmd_path, args, script)
        print(vmd_line)
    else:
        vmd_line = '%s -dispdev text -e %s' % (vmd_path, script)
    os.system(vmd_line)
    return script

