<h1> GRIB1 Viewer </h1>
This is an application written in MATLAB that can read GRIB1 files and visualize meteorological parameters. Due to size constraints, this application only includes map data for Europe.

<h2> Usage </h2>
This application is designed to allow for easy visualization of meteorological parameters from GRIB1 files. To use the application, open the main MATLAB script called "Grib_1_viewer.m" and run it. Running it will open a GUI where you can visualize GRIB 1 contents. It was tested for Windows 10 64 and Linux.

<h2> Data </h2>
The data needed for this application are GRIB edition 1. Due to size constraints, this application only includes data for a specific region.  It can visualise the following projections: regular lat-lon, lambert, rotated lat-lon. Orthographic is not supported. All previous supported projections are visualized in regular lat-lon.

<h2> Credits </h2>
This application uses code and tools from the following sources:

nctoolbox by B. Schlining, R. Signell, A. Crosby, Github repository, (https://github.com/nctoolbox/nctoolbox)
Efficient GRIB1 data reader by Shugong Wang, MATLAB Central File Exchange. Retrieved March 30, 2023. (https://www.mathworks.com/matlabcentral/fileexchange/53705-efficient-grib1-data-reader)

<h2> Purpose </h2>
The purpose of this application is to provide a simple way to visualize meteorological parameters for scientific purposes, including publishing in scientific journals. The code can be adapted for different regions.
