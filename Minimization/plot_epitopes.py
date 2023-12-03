


def create_conservation_dict(alignment_file):
    # read alignment file
    with open(alignment_file, 'r') as f:
        cons_str = ''
        seq_str = ''
        for line in f:
            if line.startswith('5I2S'):
                line = line[20:80]
                seq_str += line
                print(line)
            elif line.startswith("                    "):
                line = line[20:80]
                cons_str += line
                print(line)
    # create dictionary
    conservation_dict = {}
    resid = 1
    for i in range(len(seq_str)):
        # if not - and not number and not space
        if not seq_str[i] == '-' and not seq_str[i].isdigit():
            if not seq_str[i] == ' ' and not seq_str[i] == '\n' and not seq_str[i] == '\t':
                conservation_dict[resid] = (seq_str[i], cons_str[i])
                resid += 1
    print(conservation_dict)
    return conservation_dict
                

def main():
    create_conservation_dict('./alignment.txt')


if __name__ == '__main__':
    main()

    
    
