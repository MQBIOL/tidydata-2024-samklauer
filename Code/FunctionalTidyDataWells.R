#imports the necessary files for the tidying
library(tidyverse)
library(dplyr)
library(stringi)
library(readxl)


#This function reads in the dataframe of flourometer readings, 
#removes na columns from outside the well range and removes final column that
#contains information outside the scope of interest and renames the one column 
#we will not alter. Also removes the blank rows
Venom_start<- function(csvTitle) {
  z <- read.csv(csvTitle ,header = 3 ,sep = ",", skip =2)
  z <- z[1:length(z)-1]
  z <- z%>%
    select(-contains("X."))
  colnames(z)[1]<- 'Time'
  z <- z[rowSums(is.na(z))!=ncol(z),] #possibly alter
  return(z)
}


#This function takes in the number of samples from each well location that are taken
#over the entire time period, we will use this later to separate and tidy the data
time<- function(z) {
  samples<- unique(z$Time)
  samples <- grep('M', samples, value = TRUE)
  sample<- length(samples)
  return(length(samples))
}


#This function creates a list of the location of every single starting time in the data.
#This will also be used later to separate and tidy the data

M1finder <- function(z){
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


#This function takes our starting time and total samples functions and 
#manipulates our data into a wider format where new columns that are each 
#plate location are added. It creates a new dataframe from the first set of 
#values in each column then pulls every subsequent set from below and left joins
#it to make a very wide dataframe that we can tidy

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



#This function uses the wide_venom function and M1finder function in order to 
#adjust the columnn names to what we want before final tidying steps. It then uses 
#stringi to remove any unwanted characters in the column names. Lastly, it uses
#gsub so that the M's are removed from all values of our time column.

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
#from the other experiment plate layout dataset.
#This is also where we remove all unused wells. 
#This is done at this late step so that this code works for any 
#amount of wells used. 

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




#This function reads in the plate layout, tidies it and then unites its columns, 
#so that it can be left joint to the flourometer readings we have tidied.
#We then arrange it so that every datapoint from a well position is together in the
#data frame in time order.

Final_join <- function(csvTitle1, csvTitle2){
  fluorometer <- Tidy_time(csvTitle1)
  well_names <- read_excel(csvTitle2)
  well_names <- pivot_longer(well_names, !'...1', names_to = 'number', values_to = 'name')
  well_names <- drop_na(well_names)
  well_names <- unite(well_names, 'well position', '...1':'number', sep = "", remove = TRUE, na.rm = FALSE)
  fluorometer <- fluorometer%>%
    left_join(well_names, by = join_by('well position'))
  fluorometer <- fluorometer[order(fluorometer$'well position'),]
  return(fluorometer)
}

#Use the final function to take in the two original datasets and output the tidy
#combined dataset in csv format from all of the functions defined above
Tidy_dataset <- Final_join(
  "Raw Data/210309_flourometer_readings.csv",
  'Raw Data/210309__Experiment_PlateLayout.xlsx'
  )  
write.csv(Tidy_dataset, "Snake_Venom_Assay.csv")
