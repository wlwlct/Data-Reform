### Purpose:<br>
Deal with apd files to use the shape only. Generate <b>SecDtime file</b>, for each second, collect dtime data according to dataset calculation (use rowrange). SecDtime file contain 3 columns, first one is dtime in each time range, the second is distribution of dtime in that second in edge 1:6252, third column is intensity.

### How to run: <br>
- run <b>apds</b> first, and generate SecDtime files 
- run <b>Check_dtime_start</b>, and check wether the lifetime start from the same location (you probably need to run each section based on your requirement)
  - <b>cd</b> into the direction of desired folder called 'apd full'
  - put days into the column as the format of string in the variable called <b>days</b>
  - The figures show lifetime on mesh plot, lifetime of a molecule overlay on same plot and lifetime of all molecules measured on same day overlay on same plot.
- optional, use <b>ShiftDtime</b> to shift those decay with clear different start time.
  - <b>ba</b> is the location of the standard lifetime. The file could be choosen from the day that measured the most number of molecules.
  - <b>date</b> is chosen to be the day you want to move molecules.
  - <b>move</b> is the amount move to longer lifetime. 
  -check point is set at clearvars near save. The point could be used to check the shift.
  
