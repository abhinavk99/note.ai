import requests

def remove_some_punctuation(word):
    word = word.replace(".", "")
    word = word.replace("!", "")
    word = word.replace("?", "")
    word = word.replace(";", "")
    word = word.replace(",", "")
    return word

def has_three_consecutive_nouns(sentence):
    last_words_that_were_nouns = 0
    words = filter(lambda word: word != "and", map(remove_some_punctuation, sentence.split(" ")))
    for word in words:
        if is_noun(word):
            last_words_that_were_nouns += 1
            if last_words_that_were_nouns == 3:
                return True
        else:
            last_words_that_were_nouns = 0
    return False

def is_noun(word):
    try:
        response = requests.get("https://wordsapiv1.p.mashape.com/words/" + word + "/definitions",
            headers={
                "X-Mashape-Key": "uVoKTP7XPZmshpbJj6L1L9Y4Q7oap1jn1mzjsnrTEsfvsqdO0I",
                "Accept": "application/json"
            }
        )

        for defin in response.body["definitions"]:
            if defin["partOfSpeech"] == "noun":
                return True
        return False

    except Exception as e:
        return False
