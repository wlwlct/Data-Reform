<b>AfterPutPicinExc_CND</b> is used to generate CND file. The CND file contains three columns.<br>
Segment are determined by STaSI
* first column is averaged spectra in each segment
* second column is spectrum of segment 2 - spectrum of segment 1
* third column shows the time length of each segment

<b>AfterPutPicinExc</b> Generate image related to 
ccd with averaged wavelength; folder and file name; Intensity with experimental time; 
plot which overlay spectra (raw), lifetime and intensity together; 
plot which overlay spectra (add up), lifetime and intensity together; 
plot of spectra of first and last 10 secs 
into Excel files.

<b>AfterPutPicinExc_Change_Spectra</b> generate molecules_CND files and Change Int.xlsx file. The meaning of each column in molecules_CND files is same as structure mentioned above. The excel file contains intensity change with time; 
plot of intensity, fitted intensity, lifetime, change point on same time trace; 
plot of the spectra at current segment, at next segment, absolute difference of the next-current spectra. 

<b>AfterPutPicinExc_MeanSpectraChange</b> generates Excel file. the file contains intensity change with time; plot of intensity, fitted intensity, change point, and lifetime with time; spectral shape and intensity.

<b>Analyze</b> contains 3 plots.
* subplots of the current spectra, spectra in the next segment, spectra that increase/decrease, dwell time of before hthe current spectra take a change.
* same as the previous results, the only difference is that the diff of the spectra is sorted by the increase of the wavelength.Spectra in each wavelength section is averaged. This lead to the dwell time to be a error plot. with number of spectra averaged in yy axis right.
* subplots of diff of spectra, current spectra and next spectra. All spectra are sorted by the amount of spectral shift. negative values mean blueshift and positive values mean red sihft.
