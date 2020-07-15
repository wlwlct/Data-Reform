### Purpose
Transfer data from '*.ptu' file to '*.mat' file. 

### Prepare
- <b>'*.ptu'</b> files in a folder. 
- Name of the file is recommended to be '\*d\*d\*.mat', where the '\*' represnt the number of sample, the number of raster scan, and the number of the bight spot seperately.

### How to run
The code could be used on both bluehive and PC.
- In <b>PTU32Mat.m</b> file, change the <b>pathname</b> into the folder which contains the data and save.
- use 'sbatch run.sbatch' to upload the work into bluehive or directly run it on PC.

### Attention
The code is adoped and modified from the file provided by Hydraharp 400 from picoquant.
