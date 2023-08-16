# ScriptfuCompileImages
Script for GIMP written in Scriptfu to copy a selected rectangle area in all opened images and compile them in sets that the user defines in 1 image vertically or horizontally

Instructions to install in Gimp
1. Move compile.scm to C:\Program Files\GIMP 2\share\gimp\2.0\scripts

Instructions for use
1. Run Gimp
2. Open all images that you want to work on
3. Use Rectangle Selection tool(Press R) on 1 of the opened images to get X-coordinate, Y-coordinate, Width and Height
4. Run Compile script
5. If your opened images is not a multiple of Number of Images, the script will create blank images to make it a multiple
6. If there is a need to rerun the script, close GIMP and repeat from Step 1 to 4 or else script will have error
