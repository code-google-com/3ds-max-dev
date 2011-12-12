import sys
import os

# Import the correct module depending on the ADSKPRODUCT environment variable
if not 'ADSKPRODUCT' in os.environ:
    raise ImportError('The environment variable ADSKPRODUCT was not set') 

product = os.environ['ADSKPRODUCT']
if 'max' == product:
    import max_common as common
elif 'maya' == product:
    import maya_common as common
elif 'mobu' == product:
    import mobu_common as common
elif 'fbx' == product:
    import fbx_common as common
else:
    raise ImportError("Not a recognized product: " + product)

# A shortcut to the single instance of Application
app = common.app

def write_line(s):
    app.write_line(s)
    