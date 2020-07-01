### Purpose:<br>
Deal with apd files to use the shape only. Generate <b>SecDtime file</b>, for each second, collect dtime data according to dataset calculation (use rowrange). SecDtime file contain 3 columns, first one is dtime in each time range, the second is distribution of dtime in that second in edge 1:6252, third column is intensity.

## run
- run <b>apds</b> first, and generate SecDtime files 
- run <b>Check_dtime_start</b>, and check wether the lifetime start from the same location (you probably need to run each section based on your requirement)
- optional, use <b>ShiftDtime</b> to shift those decay with clear different start time.
