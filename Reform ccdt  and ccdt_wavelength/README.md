### Purpoes
- Select the molecule that is used as background for the ccd.
- Remove the background and recalculate ccdt_wavelength of ccd files.

### files prepare
- Generate folders for each raster scan, eg 1d1d, and move files accordingly (code demo is in the beginning of file called <b>FindBG</b>)
- Use <b>FindBG</b> to Generate excel file, which treat each molecule as background then select the proper one. Eg, if you have 5 molecules, you would have 5 &times; 5 pictures to make decision. 
  - The first column will be the average spectra shape
  - Rest columns wll be the average spectra of various molecules subtract same background.
  - The code does not provide auto save, you need to save the exel by yourself.
- Record the file name that you want to use as the background.
- load the ccdt file and generate the ave_ccdxdxdx which contains wavelength and average intensity (two columns)
- Use <b>Reform_ccdt</b> to remove background
  - Pay attention to <b>filefolder</b>, <b>regp</b>,<b>place</b>,<b>clearvars</b>
- Then move to reform apd, and use to before put excel to see select molecules that going to be run.
