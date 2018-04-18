import sys
import re

def fill_to_end(inp, i, end):
    buf = ''
    while inp[i] != end:
        buf += inp[i]
        i += 1
    return i, buf


def find_tokens(inp):
    tokens = []
    buf = ''
    i = 0
    while i < len(inp):
        c = inp[i]
        if c == 'r':
            if inp[i+1] == "'":
                i, buf = fill_to_end(inp, i+2, "'")
                tokens.append(buf)
            elif inp[i+1] == '"':
                i, buf = fill_to_end(inp, i+2, '"')
                tokens.append(buf)
            else:
                i += 1
        else:
            i += 1
    return tokens



def main():
    symbols = []
    tokens = []
    syntax_re = re.compile('syntax\s+([^ ]+)\s+::=')
    with open(sys.argv[1]) as o:
        for i, line in enumerate(o):
            m = syntax_re.search(line)
            if m:
                symbols.append(m.group(1))
            else:
                print "Missing symbol on line: %s"%i
                sys.exit(1)
            tokens.extend(find_tokens(line))
    print symbols
    print tokens




if __name__ == '__main__':
    main()
