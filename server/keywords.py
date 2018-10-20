importantWords = ["important", "neglect", "challenge", "wealthiest", "critical",
                  "severe", "relevant", "paramount", "primary", "exceptional", "significant", "momentous"]


def is_critical(str):
    for index in range(len(importantWords)):
        if importantWords[index] in str:
            return True
    return False
