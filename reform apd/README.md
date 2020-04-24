### Purpose
Remove the background of single-molecular signal by subtract the "dark region" result from each raster scan. Both ccd files and apd files would be taken into condidertation. 

### File and Folder Preparation
- Before run this code, one needs to go through the data raster scan result, remove the single molecules which are not taken properly (eg. room light, focus drift, and etc.)
- Find the file that is proper as the background by substract all possible molecules, and cross check with raster scan results to find the proper ccd and apd files that are use for background remove.
