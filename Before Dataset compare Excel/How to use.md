Folder preparation:
Inside the target folder, it contains:
  1. ccdt files
  2. apd folder with *.mat files
  3. ccdt folder with *.asc and *.mat files.
  
All files need to contain the fluorescent polymer; the wight of inert matrix material; inert matrix material; data; file label.


Code to change:

"folderlocation" is the name of parent folder of the desired folder, here called properfolder;
"properfolder" is tje name of the target folder;

Results:
  Under the main direction, {'Pathname'},{'Foldername'},{'Match Plot'}, {'Time Trace'},{'Mesh'}, {'Scatter Plot'}, {'First 1/3'},{'Second 1/3'},
%{'Third 1/3'},{'ccd Add Up'},{'asc strip'}]; is plotted. the origin data is from. ccdt file must be put outside the folder. This is generated before generate dataset files.
