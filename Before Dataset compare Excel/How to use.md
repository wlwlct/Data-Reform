# Folder preparation:
  Inside the target folder, it contains:
    -1. ccdt files
    -2. apd folder with *.mat files
    -3. ccdt folder with *.asc and *.mat files.
  
All filenames need to contain the fluorescent polymer; the wight of inert matrix material; inert matrix material; data; file label.


# Code to change:

"folderlocation" is the name of parent folder of the desired folder, here called properfolder;
"properfolder" is tje name of the target folder;

# Results:
  In the main folder, {'Pathname'},{'Foldername'},{'Match Plot'}, {'Time Trace'},{'Mesh'}, {'Scatter Plot'}, {'First 1/3'},{'Second 1/3'},
%{'Third 1/3'},{'ccd Add Up'},{'asc strip'}]; are plotted into excel file name " foldername".xlsx. This is used before generating dataset files to remove soem useless molecules, or molecules with clear feature of impurity.
