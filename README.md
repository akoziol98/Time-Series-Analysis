# Code Modules for *Finding Structure in Time: Visualizing and Analyzing Behavioral Time Series*

This is the github repository containing the five Matlab code modules with sample examples introduced in the paper, *Finding Structure in Time: Visualizing and Analyzing Behavioral Time Series*. [Here](https://psyarxiv.com/mpz9g/) is a preprint of the paper. These code modules aim to facilitate behavioral researchers to interpret and analyze high-density multi-modal behavior data, namely, to:
1) provide a step-by-step “programming basics” tutorial on importing and manipulating common behavioral timeseries data,
2) visualize the raw behavioral time series, 
3) describe the distributional structure of temporal events: Burstiness calculation. This is a method to quantify the temporal regularity of occurrence of events (Goh & Barabási, 2008), 
4) characterize the nonlinear dynamics over multiple timescales with Cross-Recurrence Quantification Analysis (CRQA) (Zbilut, Giuliani & Webber, 1998),
5) and quantify the directional relations among a set of interdependent multimodal behavioral variables with Granger Causality Granger, 1969; Bressler & Seth, 2011).
The four methods are complementary to each other, yet each module is standalone. Users can use any specific module as desired.

## System requirement and Matlab installation
Our scripts can be run on Matlab version 2018a and later versions. Matlab is available on all three main types of operating systems: Windows, macOS, and Linux. While Matlab is not free and open source which presents limitations to our users, many institutions offer Matlab for free. One can check this following website to see if a free campus license is available [here](https://www.mathworks.com/academia/tah-support-program/eligibility.html). [Here](https://www.mathworks.com/help/install/ug/install-and-activate-without-an-internet-connection.html) are the instructions for Matlab installation. Alternatively, users can install and run our code modules on GNU Octave which is open source and runs on GNU/Linux, macOS, BSD, and Windows. [This page](https://www.gnu.org/software/octave/#install) contains the installation information for GNU Octave.

For Octave users, please download *statistics* package from [here](https://octave.sourceforge.io/statistics/index.html) and *image* package from [here](https://octave.sourceforge.io/image/). After open Octave, please install and load the packages by typing the commands below: 
```
pkg install statistics-1.4.1.tar.gz
pkg load statistics
pkg install image-2.12.0.tar.gz
pkg load image
```

## STEPS to use these toolkits:
1. Download a clone of this toolkit in your local folder. You can click the green button `Clone or download` on this page to download a ZIP file. Or, if you use Git Bash, simply type in:
```
git clone https://github.com/findstructureintime/Time-Series-Analysis.git
```
2. Open Matlab and set your working path to the folder containing the downloaded toolkit.

3. Go to each module folder, view instructions in README.md/pdf and start running!
