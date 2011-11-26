import os

def save_to_file(fname, text):    
    folder = os.environ["USERPROFILE"]
    path = os.path.join(folder, "documents", fname)
    f = open(path, "w")
    f.write(text)
    f.close()
    return path


