### Folder preparation:
Inside the target folder, it contains:
- ccdt files (ccdt*)
- apd folder with *.mat files
- ccdt folder with *.asc and *.mat files (ccdt_wavelength_*)

All filenames need to contain the fluorescent polymer; the wight of inert matrix material; inert matrix material; data; file label. Inside the file label, it is in the format of '\*d\*d\*'. The three numbers indivisually present:
- the number of sample tested in the day. 
- the number of raster scan teste for the current sample
- the number of molecule measured in the current raster scan

The code wont't support name other than this...
<br>

Example:<br>

  Folder:<br>
  <p class="has-line-data" data-line-start="6" data-line-end="5"><img src="https://github.com/wlwlct/Data-Reform/blob/master/Before%20Dataset%20compare%20Excel/Pic%20for%20Readme/fileprepare%201.JPG" alt="F" width="250"></p>
  <br>
  APD:<br>
   <p class="has-line-data" data-line-start="6" data-line-end="5"><img src="https://github.com/wlwlct/Data-Reform/blob/master/Before%20Dataset%20compare%20Excel/Pic%20for%20Readme/APD.JPG" alt="A" width="250"></p>
  CCD:<br>
   <p class="has-line-data" data-line-start="6" data-line-end="5"><img src="https://github.com/wlwlct/Data-Reform/blob/master/Before%20Dataset%20compare%20Excel/Pic%20for%20Readme/ccd.JPG" alt="C" width="250"></p>
  
### Code to change:
"folderlocation" is the name of parent folder of the desired folder, here called properfolder;
"properfolder" is the name of the target folder;

### Results:
  In the main folder, {'Pathname'},{'Foldername'},{'Match Plot'}, {'Time Trace'},{'Mesh'}, {'Scatter Plot'}, {'First 1/3'},{'Second 1/3'},
%{'Third 1/3'},{'ccd Add Up'},{'asc strip'}]; are plotted into excel file name " foldername".xlsx. This is used before generating dataset files to remove soem useless molecules, or molecules with clear feature of impurity.
