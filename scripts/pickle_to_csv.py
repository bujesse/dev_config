#!/usr/local/opt/python@3.8/bin/python3
import os
import sys
import pandas as pd


def pickle_to_csv(filename):
    pickle_file = pd.read_pickle(filename)
    pickle_file.to_csv(f'{filename}.csv')


if __name__ == '__main__':
    try:
        filename = sys.argv[1]
    except IndexError:
        print('provide filename')
        sys.exit()
    if not os.path.exists(filename):
        print('file does not exist')
        sys.exit()
    pickle_to_csv(filename)
