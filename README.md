# Generate .Scan file to PDF and XML Report.
This batch automation streamlines HCL AppScan report generation.<br>
It detects the local folder for “.scan” files, then automatically produces PDF and XML reports using the custom template “all” with minimum severity “informational.”<br>
Generated files are organized into PDF and XML subfolders, and processed “.scan” files are moved into a Scan archive folder.

# Structure of project
generate_reports.bat — main batch script automating report creation<br>
Input Folder (root) — contains all raw .scan files<br>
/PDF/ — stores generated PDF reports<br>
/XML/ — stores generated XML reports<br>
/Scan/ — archive folder for completed .scan files<br>
appscancmd.exe — HCL AppScan command-line tool (must be in PATH or same directory)<br>
Report Template — custom template named “all” used for consistent formatting<br>
Severity Filter — applies min_severity informational to include all issue levels<br>
Automation Logic — loops through each .scan, generates both reports, validates success, then moves processed files<br>

# How to excute the bat script
1.Open AppScan Standard<br>
2.Create custom report template named all<br>
3.Copy this report.bat script to the folder where your .scan files are located
4. Run Script<br>
```
.\report.bat
```

# Full syntex
For full Report syntex, please vist HCL Software AppScan Product documentation
https://help.hcl-software.com/appscan/Standard/10.9.0/r_ReportCommand004.html
