<h1 align = "center">
Final Tidy Data
</h1>

Data: Snake Venom Protein Activity Assay Data from 03/09/21

Authors: Abhinandan Chowdhury and Dr. Christina Zdenek, working in the group of A/Prof Bryan Fry

Location: University of Queensland, QLD Australia

This is a csv file that shows the actual fluorescent activity readings taken by a fluorometer, likely in relative fluorescent units, of each of the liquids in their specific well positions at all 300 time points of measurments taken. This data is 4 columns of 22800 oservations, or better known as the time point data for each of the 76 well locations across the 300 time points. Every single specific well is grouped together with all of its time data in order. This is described in four columns:

<h2 align = "center">
Time
</h2>
Time is the time point of the specific well in question from 1-300. This is unitless time.

<h2 align = "center">
Well Position
</h2>
Well position is its position within the original experiment layout A1-H10 (E1, F1, G1, and H1 in this range are unused for this experiment). All values at each time point 1-300 of each well position are grouped together, so that the change across time for a specific well is easily seen. 

<h2 align = "center">
Value
</h2>
This is the actual raw output from the fluorometer. The fluorescent activity is found in this column (likley in relative fluorescent units, due to the negative values at some places).

<h2 align = "center">
Name
</h2>
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

*This description of "FX" was not in the original overview of the data and was assumed based on the descriptions in the overview of the data, any questions regarding this should be placed to the original authors
