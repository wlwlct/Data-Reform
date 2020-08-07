### Purpoes
- Select the molecule that is used as background for the ccd.
- Remove the background and recalculate ccdt_wavelength of ccd files.

### files prepare
- Generate folders for each raster scan, eg 1d1d, and move files accordingly
- Generate excel file, which treat each molecule as background then select the proper one. Eg, if you have 5 molecules, you would have 5 &times; 5 pictures to make decision. (The code is located in the second part and require the use of the ‘Pic2Excel_general’ function.)
- Then move to reform apd, and use to before put excel to see select molecules that going to be run.
