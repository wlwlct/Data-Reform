# Data-Reform
## How to use
- Collect raw apd files and ccd files from lab
- Put apd files onto bluehive, then use <b>PTU2mat</b> to convert to mat
- Put ccd (\*.asc) files into a folder, then use <b>GenCCD</b> to generate and select single molecule files for further study.
- (<b>reform apd</b> and <b>Reform ccdt and ccdt_wavelength</b> are used to remove the background of all data; Regenerate excel files as needed)
- Rename files and run <b>Before Dataset compare Excel</b> to select files that would go through <b>Bluehive-SMS</b>
- (use <b>select and move </b> to find matching apd and ccd files)
- Use <b>Bluehive-SMS</b> to generate dataset files
- Use <b>After Dataset compare Excel</b> to generate excel file for checking.
- After receiving dataset files, use <b>apds</b> to generate SecDtime files for <b>SMS-properties</b> study
