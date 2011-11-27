Python Script Launcher Project
==============================

This project creates a custom user action for launching Python scripts.

1) you have to copy the DLL files from the install folder to the root folder of 3ds Max 2012.
2) After building copy the generated DLL from (obj\Debug) to the bin\assemblies folder of 3ds Max 2012.

The next time you run 3ds Max 2012 you will need to open up the Customization dialog and look for the 
command "Run Python script" in the category ".NET Utilities". 

To test the system try running the script "scripts/output_scene.py"