import os
from yaml import load, dump
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper

def mkdir(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)
    return directory

def mksymlink(src, dst):
    if not os.path.exists(dst):
        os.symlink(src, dst)
    return dst

def rmfile(filename):
    if os.path.exists(filename):
        os.remove(filename)
    return filename

def rmfiles(filenames):
    for filename in filenames:
        rmfile(filename)
    return filenames

def rmfilesbyext(directory, ext):
    for filename in os.listdir(directory):
        if filename.endswith(ext):
            rmfile(os.path.join(directory, filename))
    return directory

def rmfilesbyexts(directory, exts):
    for filename in os.listdir(directory):
        for ext in exts:
            if filename.endswith(ext):
                rmfile(os.path.join(directory, filename))
    return directory

def rmfilesbyregex(directory, regex):
    for filename in os.listdir(directory):
        if re.search(regex, filename):
            rmfile(os.path.join(directory, filename))
    return directory

def loadyaml(yaml_file):
    with open(yaml_file, 'r') as f:
        return load(f, Loader=Loader)

def chdir(directory):
    os.chdir(directory)
    return directory
