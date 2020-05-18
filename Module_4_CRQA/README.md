# Module 3: Cross-recurrence quantification analysis of dyadic interaction

With these five MATLAB scripts you can perform cross-recurrence quantification analysis (CRQA) on categorical data. 

Start MATLAB or Octave and select the folder where the provided material (M-functions and data file) is located. That is, make MATLAB/Octave’s current folder equal to the folder to which you downloaded the GitHub folder of this module (e.g. ‘C:\...\My Documents’). After this you can call these functions on the command line.

If you are using Octave, please install the *statistics* package from [here](https://octave.sourceforge.io/statistics/index.html). Then install and load the package prior to running the demo script:
```
pkg install statistics-1.4.1.tar.gz
pkg load statistics
```

1. First run the following code: 
```matlab
load(‘example_data.mat’)
```

Hint: Either copy-paste to an empty MATLAB script file and then run it, or copy-paste the lines in each individual assignment to the command line followed by ‘enter’.

You have just loaded two time series, PP1 and PP2, into the Workspace, but the data could be any two nominal data streams of equal length. These time series consist of nominal data having integer values from 1 to 5. The time series come from a dyadic interaction study, collaborative behaviors of two children was coded from video at 1 Hz by using the same five specific behavioral categories for each.

2. Plot these time series to see what they look like. Run:
```matlab
plotTS(PP1, PP2);
```

3. Next step is to create the cross-recurrence matrix, *rec*, by running the following:
```matlab
rec = CatCRMatrix(PP1,PP2);
```

Have a look at the M-function *CatCRMatrix* and try to understand what it does. Also, have a look at the matrix rec consisting of 1630 × 1630 points. The analysis distinguishes between two types of behavioral matches, which represent different combinations of behaviors of the interaction partners. Each combination corresponds to a different value (+1 or -1) in the recurrence matrix rec. All other combinations are considered to be non-matching and obtain the value 0.

Note: For nominal data you can directly build-up the cross-recurrence matrix by comparing the values in the two time series. In the cross-recurrence plot (CRP) a dot (i.e. recurrent point) is plotted whenever these values match in a pre-specified way. This first creates the main diagonal (Line-of-Synchrony) of the CRP, containing the equal-time behavioral matches. But by shifting the time series with respect to each other in both directions, lines parallel to the Line-of-Synchrony on both sides are created. Each of these lines reflects the behavioral matches with a specific (increasing) delay between the occurrence of those behaviors in the two time series.

4. Now let’s plot the CRP to study its structure, by running this:
```matlab
PlotCRP(rec)
```

Note: This is a typical checkerboard pattern you would expect for nominal CRQA. There are three colors in this CRP representing the three different types of states of the dyadic system, based on the numerical values in rec: red for the value +1, blue for the value -1, and white for the value 0. All together the CRP nicely displays the rich coordinative structure of the dyadic interaction across all possible timescales.

5. 5. Finally, we will calculate several CRQA measures from this CRP, in order to quantify its structure. Run the following function:
```matlab
[Chromatic_CRQA , Anisotropic_CRQA] = CRQA_out(rec)
```

his function performs **Chromatic CRQA** and **Anisotropic CRQA** on the data, and provides two output files.

The first output file, *Chromatic_CRQA*, presents the recurrence rate, RR, for the red areas in the upper row and for the blue areas in the lower row. RR is given both as a proportion of the total number of points in the CRP (first column) and as a proportion of the total number of behavioral matches (second column).

Note: The recurrence rate quantifies the density of each particular behavioral match as distinguishes in the analysis (i.e. red and blue). In that sense, the two values of *RR* presented in the output file reflects the extent to which the behaviors of one child match those of the other child in one of two specific ways (corresponding to red or blue), across all possible time scales. The recurrence rate is a crude measure of the dyadic coordination.

The Anisotropic CRQA performed here ignores the different types of behavioral matches (i.e. colors in the CRP), and treats them all as equal. The analysis quantifies both the vertical and horizontal patterns. It produces the following measures:

*LAM* = Proportion of matches in vertical/horizontal patterns

*TT* = Average length of vertical/horizontal patterns

*MaxL* = Length of the longest vertical/horizontal pattern

*ENT_L* = Shannon entropy of vertical/horizontal length distribution

You can have a look at the results in the command window or by opening the output file*Anisotropic_CRQA* from the Workspace. There are two rows in *output*. The upper row gives the values for the vertical patterns; the lower row those for the horizontal patterns.

Note: By calculating these measures in both the vertical and horizontal orientation and comparing them, Anisotropic CRQA enables you to study asymmetries in the dynamics. Differences between these measures reflect differences in relative contribution and dominance between the interaction partners.

For more information about Chromatic CRQA and Anisotropic CRQA on nominal data see:

Cox, R.F.A., Van der Steen, S., De Jonge-Hoekstra, L., Guevara, M., & Van Dijk, M. (2016). Chromatic and anisotropic cross-recurrence quantification analysis of interpersonal behaviour. In C. Webber, C. Ioana, & N. Marwan (Eds). Recurrence Plots and Their Quantifications: Expanding Horizons (pp. 209-225). Springer Proceedings in Physics. ([link](https://www.researchgate.net/publication/299511690_Chromatic_and_Anisotropic_Cross-Recurrence_Quantification_Analysis_of_Interpersonal_Behavior))

This code module is written by [Dr. R.F.A. (Ralf) Cox](https://www.rug.nl/staff/r.f.a.cox/), if you have any question please contact *r.f.a.cox at rug.nl*.