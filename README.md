<h1 align = "center">
Tidying of Snake Venom Assay Data
</h1>

Contains R code for tidying snake venom data

<h2 align = "center">
Aims and Folder Descriptions
</h2>

This is a project in QBIO7006 at UQ in which I take in an untidy csv and xlsx file and tidy them and produce a tidy csv file. The raw data input along with its metadata is found within the "Raw Data" folder. The code to tidy this and similar data is found in the "Code" folder. The output file along with its metadata is found in the "Final Tidy Data" folder. This code is designed to work on any protein activity assay data of any size in which the data takes the form of the raw data in the "Raw Data" folder (metadata found in the readme in that folder).

<h2 align = "center">
Dependencies
</h2>

R version 4.3.2 (2023-10-31) was used for all code contained within this repository 

Install the following R packages if they are not on your system:

• tidyverse

• dplyr

• stringi

• readxl

You can install them with the code below:

```{r}
install.packages(tidyverse)
install.packages(dplyr)
install.packages(stringi)
install.packages(readxl)
```

<h2 align = "center">
Background
</h2>

This background information is taken from the Overview of the Snake Venom Data from the Tidy Data Set Assignment given in QBIO7006 semster 1 2024:

"Many snake venoms cause blood to clot. For those animals (including humans) that are unlucky enough to be bitten, this is a big problem. However, compounds that cause clotting could also have important medical applications. Watch https://youtu.be/BtJ0g_78i6I where UQ researchers show and discuss these properties of snake venoms; the data that you will be examining is based on their research program. Venoms include many chemical compounds. An important tool for trying to identify which specific enzymes in the venom cause a specific effect uses fluorometry where, when a specific reaction occurs, a florescent reaction (light) is generated. For example, in the diagram below, if the venom activates a specific compound, that compound releases a “quenched” florescent molecule from a target substrate and this activity is detected as light.


<p align = "center">
<img width="300" alt="image" src="https://github.com/MQBIOL/tidydata-2024-samklauer/assets/61903817/5bc84f73-7847-4f5e-adb5-f5cbee16d447">
</p>


A typical experimental design includes:
•	Blanks: no venom, negative control
•	Activated factors: “FX activated factor”, a positive control
•	Experimental wells: venom + FX
•	Venom only: gives the baseline florescent of the venom

Acknowledgments: Data and information from Abhinandan Chowdhury and Dr. Christina Zdenek, working in the group of A/Prof Bryan Fry "

<h2 align = "center">
Authors
</h2>
The raw data and background information was provided by Abhinandan Chowdhury and Dr. Christina Zdenek, working in the group of A/Prof Bryan Fry. 

The repository and all code was written by:

Sam Klauer https://github.com/samklauer
