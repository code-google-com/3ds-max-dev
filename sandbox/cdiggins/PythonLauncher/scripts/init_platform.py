import os

def _init_platform(s):
    os.environ['ADSKPRODUCT'] = s

def init_max():
    _init_platform('max')

def init_maya():
    _init_platform('maya')

def init_mobu():
    _init_platform('mobu')

def init_fbx():
    _init_platform('fbx')

def get_platform():
    return os.environ['ADSKPRODUCT']

