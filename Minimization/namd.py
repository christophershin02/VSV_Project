import os

def write_namd_conf(template_file, toppar_path):
    # read in the template
    with open(template_file, 'r') as f:
        template = f.read()
    output = template.format(toppar_path=toppar_path)
    # write out the new file
    with open('namd.conf', 'w') as f:
        f.write(output)
    return 'namd.conf'

def write_namd_pair_interactions_conf(template_file, toppar_path, pair_interaction_file):
    out_conf_file = 'pair_int.conf'
    # read in the template
    with open(template_file, 'r') as f:
        template = f.read()
    output = template.format(toppar_path=toppar_path, 
                             pair_interaction_file_path=pair_interaction_file)
    # write out the new file
    with open(out_conf_file, 'w') as f:
        f.write(output)
    return out_conf_file

def run_namd(namd_path, conf_file):
    conf_basename = os.path.basename(conf_file)
    os.system('%s +p12 %s > %s.log' % (namd_path, conf_file, conf_basename))
    return conf_file
