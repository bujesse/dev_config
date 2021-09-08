#!/usr/bin/env python3

"""
Delete all files that do not have the same name as another file.
Useful for cleaning up raw or jpg duplicate files when you've deleted one of them in LR.
"""

import glob
import os
import sys
import argparse

IGNORED_FILES = ['.py']


def main(arguments):
    files_to_delete = set()
    for file in os.listdir():
        filepath = os.path.join(os.getcwd(), file)
        filename, ext = os.path.splitext(filepath)
        if len(glob.glob(f'{filename}.*')) < 2 and ext not in IGNORED_FILES:
            print('Staged for Deletion: ', file)
            files_to_delete.add(file)

    should_delete = input(f'\n{len(files_to_delete)} file(s) staged for deletion. Delete these files? (y/n)')
    if should_delete == 'y':
        for file in files_to_delete:
            print('Deleting: ', file)
            os.remove(file)
    else:
        print('No files deleted')
    sys.exit()


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))

