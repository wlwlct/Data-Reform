### Purpose
This code is designed to generate the ccd spectra. It is designed to run on PC and visually check and select the file for further single molecule analysis.

### Prepare
- Put 'asc' files into one folder. The name of the file is better named as '\*d\*d\*.asc', where the numbers represent the number of sample, the number of raster scan, and the number of bright spots. 
- Open a note book to write the Spectrum specification. Record the number of max row (jmax), shift, one row or multiple row, special files for future test and where average wavelength is calculated.
  
### How to use
- Change <b>srcDir</b> into the direction of folder that contains asc files.
- Check point set before 'saveas'.
- Open the function <b>Genccdwl</b>
- Check pont is set at the end of PART I, check weather the spectra are located at one row or multiple rows. If all spectra are on multiple rows, 'sum of jmax' needs to be adapted to jmax:jmax+1 or jmax-1:jmax+1 as needed.
- Check point is set at PART II, find and record the jmax. If it is not what you expected, it might due to spikes.
- Check point is set at PART IV after mesh. The point is used to check whether there is spike.
- Run the <b>batchspectrum.m</b>. Check the results along the way, select the data you want to use for further analysis.
