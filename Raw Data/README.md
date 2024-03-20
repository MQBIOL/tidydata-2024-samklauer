<h1 align = "center">
Project Information
</h1>

Data: Snake Venom Protein Activity Assay Data from 03/09/21*

Authors: Abhinandan Chowdhury and Dr. Christina Zdenek, working in the group of A/Prof Bryan Fry

Location: University of Queensland, QLD Australia 

<h1 align = "center">
Data Overview
</h1>

<h2 align = "center">
Experiment Plate Layout
</h2>
File: 210309__Experiment_PlateLayout.xlsx

This is an excel file that takes the exact shape of the well plate that was usued within the expirment. Here the columns are labelled 1-24 and the first row is labelled A-P. This allows the inner region to each have an individual descriptor A1-P24. Every single cell corresponds to a location on the wells as shown below and any cell that has a liquid pipetted into it is labelled within this file (for instance A1 is blank and E3 is V.ammo + FX). Here only A-H and 1-10 have data in them (because this was the range of wells used within this experiment), with some wells in this range being entirely unused as well (E1, F1, G1, and H1). 

This is the name of what is actually in each specific well A1-H10. A description of the names were provided in the background section and can be found below:

•	Blanks: no venom, negative control (A1, B1, C1, D1)

•	Activated factors: “FX activated factor”, a positive control, labelled as "FXA" (A2, B2, C2, D2)

•	* Inactive Factors: "FX" (E2, F2, G2, H2)

•	Experimental wells: venom + FX

•	Venom only: gives the baseline florescent of the venom

In both the experimental wells (E3:H10) and the venom only wells (A3:D10) the venom in each are as follows (X indicating any letter):

•	X3: V. ammo

•	X4: V.a. meri

•	X5: V. aspis

•	X6: V.berus

•	X7: V. kaza

•	X8: V.lat.gad

•	X9: V. renardi

•	X10: M.l.turan

<p align = "center">
<img width="300" alt="image" src="https://github.com/MQBIOL/tidydata-2024-samklauer/assets/61903817/ddcfc7c3-232d-4884-9848-df831807334d">
</p>

<h2 align = "center">
Fluorometer Readings
</h2>
File: 210309_flourometer_readings.csv

This is a csv file that shows the actual fluorescent activity readings taken by a fluorometer, likely in relative fluorescent units*, of each of the liquids in their specific well positions at all 300 time points* of measurments taken. This data is formatted as multiple readings stacked on top of each other, starting with columns 2-5 of the data being the wells in column 1 of the actual experiment ('A1', 'B1', etc.) all labelled as 'M:A1', 'M:B1', etc. (This extends all the way to M:P1, but M:E1 - M:P1 have no data). The first row of this csv is the unlablled column of time which shows all 300 of the timepoints labelled "M1"-"M300" and repeats for every subsequent column of wells from the experiment itself. As mentioned before this repeats lower down in the csv file for the next column of wells from the experiment (A2-H2) all labelled as 'M:A2', 'M:B2', etc. The M1-M300 restarts at the beginning of these readings and these readings also have the blank (M:I2-M:P2). Every subsequent grouping of 300 (columns 3-10) follows the exact same format as the data from the second column of the original experiment outlined directly above. 

There are also a multitude of entirely empty and unlabelled columns in the raw csv file following the empty M:P1 column, ending with a final column on the far right of the file that contains numbers in a few of the cells that are not important to our results. 


<h2 align = "center">
Uncertainties*
</h2>

- The date is assumed from the title of the raw data

- The relative fluorescent units was assumed due to the nature of the data having negative values
  
- The description of "FX" was not in the original overview of the data and was assumed based on the descriptions in the overview of the data

- units and time between readings is unknown

Any questions regarding these specifics should be placed to the authors of the original raw data and background information
