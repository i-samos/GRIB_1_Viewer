<h1> GRIB1 Viewer </h1>
<h2> A MATLAB Application for Visualizing Meteorological Parameters </h2>

![Example Image](https://github.com/i-samos/GRIB_1_Viewer/blob/main/Windows%2010/splash.png)


This is an application written in MATLAB that can read GRIB1 files and visualize meteorological parameters. Due to size constraints, this application only includes map data for Europe.

<h2> Usage </h2>

The purpose of this application is to provide an easy way to visualize meteorological parameters from GRIB1 files. To use the application, open the main MATLAB script called "Grib_1_viewer.m" and run it. When the script is executed, it will open a graphical user interface (GUI) that allows you to visualize the contents of the GRIB1 files. This application has been tested on both Windows 10 64 and Linux platforms. If you want to use the application on Linux, you will need to alter the "Grib_1_viewer.m" file by replacing the backslashes "\" with forward slashes "/" and copying it to the appropriate Linux folder.

The INPUT_GRIB directory is a required component of the application, as it contains sub-folders that represent different models. Each sub-folder must contain files with the same projection in order for them to be read correctly. Additionally, the GRIB files within the sub-folders must have a ".grb" extension (e.g. "test.grb") in order to be recognized by the application. Finally, the "stations.xls" file is also a required component to allow for point stations to be plotted during the first load. This application has been tested with MATLAB versions 16b and 17a.

<h2> Code Modifications and Future Work </h2>
This application uses C code for MEX files, which has been modified to export the output to a text file in the filesystem and then read the text file back into MATLAB. This was done as a temporary solution until further work can be done to properly modify the code to assign the data to a matrix inside MATLAB. Future work for this application can include modifying the code to read GRIB2 files using nctoolbox. Currently, the application only supports GRIB1 files due to limitations with the code. By extending the capabilities of the application to read GRIB2 files, users can expand the range of data that can be visualized.

<h2> Data </h2>
This application requires GRIB edition 1 data to function properly. Due to size limitations, the application only includes data for a specific region. The application can visualize data in several projections, including regular lat-lon, Lambert, and rotated lat-lon. However, orthographic projection is not currently supported. All of the previously mentioned projections will be visualized in the regular lat-lon projection.

<h2> Credits </h2>
This application uses code and tools from the following sources:

nctoolbox by B. Schlining, R. Signell, A. Crosby, Github repository
(https://github.com/nctoolbox/nctoolbox)

export_fig by Oliver Woodford and Yair Altman, GitHub repository
(https://github.com/altmany/export_fig/releases/tag/v3.34)

Efficient GRIB1 data reader by Shugong Wang, MATLAB Central File Exchange
(https://www.mathworks.com/matlabcentral/fileexchange/53705-efficient-grib1-data-reader)

Wind barb plotter by Nicholas, MATLAB Central File Exchange
(https://www.mathworks.com/matlabcentral/fileexchange/33851-wind-barb-plotter)

MY_XTICKLABELS by Pekka Kumpulainen, MATLAB Central File Exchange
(https://www.mathworks.com/matlabcentral/fileexchange/19059-my_xticklabels)

maximize by Oliver Woodford, MATLAB Central File Exchange
(https://www.mathworks.com/matlabcentral/fileexchange/25471-maximize)

<h2> Purpose </h2>
This application is designed to offer an uncomplicated method for visualizing meteorological parameters for scientific purposes, such as publishing in scientific journals. The code is flexible and can be adapted to function in various regions.
