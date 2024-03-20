#Import the necessary files for the tidying
library(tidyverse)
library(dplyr)
library(stringi)
library(readxl)


#This function reads in the csv of flourometer readings, ensures it's a
#file, saves it as a datadrame,removes columns from outside the well range 
#(anything beyond A-P) and removes final column that contains information 
#outside the scope of interest and renames the one column we will not alter that
#contains the time.

Venom_start<- function(csvTitle) {
  if(class(csvTitle)!= "character"){
    stop(paste0("Please input the csv file name in quotations, input class was ", class(csvTitle)))
  }
  if(file.exists(csvTitle)== FALSE){
    stop(paste0("File path not found. If you are working on the repository raw 
    data, ensure you set your directory to the tidydata-2024-samklauer 
    for the correct relative path."))
  }
  z <- read.csv(csvTitle ,header = 3 ,sep = ",", skip =2)
  z <- z[1:length(z)-1]
  z <- z%>%
    select(-contains("X."))
  colnames(z)[1]<- 'Time'
  return(z)
}


#This function takes in the dataframe, ensures its a dataframe with the time column
#and returns the number of samples from each well location that are taken
#over the entire time period, we will use this later to separate and tidy the data.

time<- function(z) {
  if(class(z)!= "data.frame"){
    stop(paste0("Please input dataframe, not ", class(z)))
  }
  if('Time' %in% names(z)!= TRUE){
    stop(paste0("Please ensure column dealing with time data is labelled, 'Time'.
    This was done for you in Venom_start."))
  }
  samples<- unique(z$Time)
  samples <- grep('M', samples, value = TRUE)
  sample<- length(samples)
  return(length(samples))
}


#This function in the dataframe, ensures its a dataframe with the time column
#and creates a list of the row number of every single starting time in the data.
#This will also be used later so we can access the first sample of every well 
#to separate and tidy the data.

M1finder <- function(z){
  if(class(z)!= "data.frame"){
    stop(paste0("Please input dataframe, not ", class(z)))
  }
  if('Time' %in% names(z)!= TRUE){
    stop(paste0("Please ensure column dealing with time data is labelled, 'Time'.
    This was done for you in Venom_start."))
  }
  ind = 0
  M1list <- list()
  for (i in 1:length(z$Time)){
    if (z$Time[i] == "M1"){
      ind = ind + 1
      M1list[ind] = i
      next
    }
  }
  return(M1list)
}


#This function takes our M1finder and time functions to get the exact row range
#of each subset of the data and manipulates our data into a wider format where new 
#columns that are each plate location are added. It creates a new dataframe from
#the first set of values in each column then pulls every subsequent set from 
#below and left joins it to make a very wide dataframe that we can tidy.

wide_venom <- function(csvTitle){
  dat <- Venom_start(csvTitle)
  t <- time(dat)
  First <- M1finder(dat)
  for (i in First){
    if (as.numeric(i) ==1){
      dat2 <- dat[i:t,]
      next
    }
    else if (as.numeric(i) !=1){
      dat2<-dat2%>%
        left_join(dat[as.numeric(i):as.numeric(t-1+i),], by = join_by(Time), 
                  relationship = "many-to-many") 
      next
    }
    break
  }
  return(dat2)
}



#This function uses the wide_venom function and M1finder function to grab the rows
#in the original data which contain the well position names in order to 
#adjust the column names to what we want before final tidying steps. It then uses 
#stringi to remove any unwanted characters in the column names. Lastly, it uses
#gsub so that the M's are removed from all values of our time column.
#This function's purpose is to organize the data so that after tidying,
#no renaming needs to occur within this dataframe. 

correct_col <- function(csvTitle){
  dat <- wide_venom(csvTitle)
  dat2 <- Venom_start(csvTitle)
  First <- M1finder(dat2)
  loc_list <- list()
  ind = 0
  for(i in First){
    ind = ind + 1
    loc_list[ind] <- list(dat2[i-1,])
    }
  loc_list <- do.call(c, unlist(loc_list, recursive = FALSE))
  loc_list <- loc_list[loc_list != ""]
  loc_list <- unname(loc_list)
  colnames(dat)[18:length(dat)] <- loc_list
  names(dat) = stri_replace_all_regex(
    names(dat),
    c('M', '\\:', '\\.', 'x'),
    c(' ',' ',' ',' '),
    vectorize = FALSE
  )
  dat$Time <- gsub("M", "", dat$Time)
  return(dat)
}


#This function tidies our data so that we can add the names of samples 
#from the experiment plate layout dataset.This is also where we remove all 
#unused wells. This is done at this late step so that this code works for any 
#amount of wells used and previous code can be checked if anyone else runs this
#code with different data in the future. 

Tidy_time <- function(csvTitle){
  data <- correct_col(csvTitle)
  data[2:length(data)] <- lapply(data[2:length(data)],as.numeric)
  data <- data[ , colSums(is.na(data))==0]
  data <- pivot_longer(data, !'Time', names_to = 'well position', 
                       values_to = 'value')
  data$'well position'<- gsub(x = data$'well position', pattern = " ",
                                      replacement = "")
  return(data)
}




#This function reads in the plate layout, esnures it's a file, saves it as a 
#dataframe tidies it and then unites its columns, so that it can be left joint 
#to the flourometer readings we have tidied.We then arrange it so that every 
#datapoint from a well position is together in the data frame in time order. 
#Lastly, it moves the florescent activity value column to the far right.

Final_join <- function(csvTitle1, csvTitle2){
  if(class(csvTitle2)!= "character"){
    stop(paste0("Please input the xlsx file name in quotations, input class was ", class(csvTitle)))
  }
  else if(file.exists(csvTitle2)== FALSE){
    stop(paste0("File path not found. If you are working on the repository raw 
    data, ensure you set your directory to the tidydata-2024-samklauer 
    for the correct relative path."))
  }
  flourometer <- Tidy_time(csvTitle1)
  well_names <- read_excel(csvTitle2)
  well_names <- pivot_longer(well_names, !'...1', names_to = 'number', values_to = 'name')
  well_names <- drop_na(well_names)
  well_names <- unite(well_names, 'well position', '...1':'number', sep = "", remove = TRUE, na.rm = FALSE)
  flourometer <- flourometer%>%
    left_join(well_names, by = join_by('well position'))
  flourometer <- flourometer[order(flourometer$'well position'),]
  flourometer <- flourometer %>% relocate(value, .after = name)
  return(flourometer)
}

#Use the final function to take in the two original datasets and output the tidy
#combined dataset in csv format from all of the functions defined above.

Tidy_dataset <- Final_join(
  "Raw Data/210309_flourometer_readings.csv",
  "Raw Data/210309__Experiment_PlateLayout.xlsx"
  )  
write.csv(Tidy_dataset, "Final Tidy Data/Snake_Venom_Assay.csv")
