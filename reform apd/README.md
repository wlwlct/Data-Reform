### Purpose
Remove the background of single-molecular signal by subtract the "dark region" result from each raster scan. Both ccd files and apd files would be taken into condidertation. 

### File and Folder Preparation


### How to use
- optional (Before run this code, one needs to go through the data raster scan result, remove the single molecules which are not taken properly (eg. room light, focus drift, and etc.))
- Run <b>Reform ccdt and ccdt_wavelength</b>, find the file that is proper as the background by substract all possible molecules, and cross check with raster scan results to find the proper molecular name that are use for background remove.
- Run <b>Reform_apd_V2</b>. This code will remove the background according to the distribution shape.
  - <b>fn</b> and <b>rn</b> contains the string for folder and file name for the background 
  - <b>filefolder</b> change to the folder that contains files
  - <b>names</b> change to name related to the file names, such as '\*d\*d\*'
  - <b>v</b> is chosen to select all raw data variables in the workspace
  - <b>BG</b> is set to the name of background files name. 
  - <b>bin_min</b> is used to select the range use for background remove. It needs to be as large as possible.
  - Pay attention to <b>clearvars</b> to avoid errors.
