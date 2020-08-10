### Purpose
Remove the background of single-molecular signal by subtract the "dark region" result from each raster scan. Both ccd files and apd files would be taken into condidertation. 

### File and Folder Preparation
- optional (Before run this code, one needs to go through the data raster scan result, remove the single molecules which are not taken properly (eg. room light, focus drift, and etc.))
- Run ccd reform, find the file that is proper as the background by substract all possible molecules, and cross check with raster scan results to find the proper molecular name that are use for background remove.
- Run <b>Reform_apd_V2</b>. This code will remove the background according to the distribution shape.
  - Pay attention to <b>filefolder</b>, <b>names</b>, <b>v</b>, <b>BG</b>, <b>clearvars</b>, <b>bin_min</b>
