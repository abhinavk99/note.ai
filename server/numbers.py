import re


def has_numbers(line):
    searchObj = re.search(r'[0-9]', line, re.M | re.I)
    return True if searchObj else False
