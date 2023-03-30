<h1> GRIB1 Viewer </h1>
This is an application written in MATLAB that can read GRIB1 files and visualize meteorological parameters. Due to size constraints, this application only includes map data for Europe.

<h2> Usage </h2>

The purpose of this application is to provide an easy way to visualize meteorological parameters from GRIB1 files. To use the application, open the main MATLAB script called "Grib_1_viewer.m" and run it. When the script is executed, it will open a graphical user interface (GUI) that allows you to visualize the contents of the GRIB1 files. This application has been tested on both Windows 10 64 and Linux platforms. If you want to use the application on Linux, you will need to alter the "Grib_1_viewer.m" file by replacing the backslashes "\" with forward slashes "/" and copying it to the appropriate Linux folder.

The INPUT_GRIB directory is a required component of the application, as it contains sub-folders that represent different models. Each sub-folder must contain files with the same projection in order for them to be read correctly. Additionally, the GRIB files within the sub-folders must have a ".grb" extension (e.g. "test.grb") in order to be recognized by the application. Finally, the "stations.xls" file is also a required component to allow for point stations to be plotted during the first load. This application has been tested with MATLAB versions 16b and 17a.

<h2> Data </h2>
This application requires GRIB edition 1 data to function properly. Due to size limitations, the application only includes data for a specific region. The application can visualize data in several projections, including regular lat-lon, Lambert, and rotated lat-lon. However, orthographic projection is not currently supported. All of the previously mentioned projections will be visualized in the regular lat-lon projection.

<h2> Credits </h2>
This application uses code and tools from the following sources:


nctoolbox by B. Schlining, R. Signell, A. Crosby, Github repository
(https://github.com/nctoolbox/nctoolbox)

Efficient GRIB1 data reader by Shugong Wang, MATLAB Central File Exchange. Retrieved March 30, 2023. 
(https://www.mathworks.com/matlabcentral/fileexchange/53705-efficient-grib1-data-reader)

export_fig by Oliver Woodford and Yair Altman, GitHub repository
(https://github.com/altmany/export_fig/releases/tag/v3.34)

<h2> Purpose </h2>
This application is designed to offer an uncomplicated method for visualizing meteorological parameters for scientific purposes, such as publishing in scientific journals. The code is flexible and can be adapted to function in various regions.
