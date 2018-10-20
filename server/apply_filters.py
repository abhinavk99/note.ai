from keywords import is_critical
from numbers import has_numbers
from nouns import has_three_consecutive_nouns


def is_good(sen):
    if is_critical(sen):
        return True
    elif has_numbers(sen):
        return True
    elif has_three_consecutive_nouns(sen):
        return True
    else:
        return False


def apply_filters(source):
    source = source.replace("!", ".")
    source = source.replace("?", ".")
    sentences = filter(lambda s: s.strip(), source.split("."))
    sentences = filter(is_good, sentences)
    return sentences
