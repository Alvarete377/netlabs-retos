import hashlib


def flag_for(seed: str) -> str:
    digest = hashlib.sha256((seed + "netlabs").encode()).hexdigest()
    return "NL{" + digest[:16] + "}"
