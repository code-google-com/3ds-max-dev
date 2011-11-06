def first(iterable):
    for item in iterable:
        return item
    raise ValueError('Empty sequence')

def first_or_none(iterable):
    for item in iterable:
        return item
    return None
