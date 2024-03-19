#imports the necessary files for the tidying
library(tidyverse)
library(dplyr)
library(stringi)
library(readxl)

# reads in dataframe of well time results, 
#removes na columns from outside the well range and removes final column that
#contains information outside the scope of interest and renames the one column 
#we will not alter. Also removes the blank rows
Venom_start<- function(csvTitle) {
  z <- read.csv(csvTitle ,header = 3 ,sep = ",", skip =2)
  z <- z[1:length(z)-1]
  z <- z%>%
    select(-contains("X."))
  colnames(z)[1]<- 'Time'
  z <- subset(z, M.A1!= "") #possibly alter
  return(z)
}

#venom_data <- Venom_start("/Users/samklauer/Desktop/QBIO7006/210309_flourometer_readings.csv")

#This function takes in the number of samples from each well location are taken
#over the entire time period, we will use this later to separate and tidy the data
time<- function(z) {
  samples<- unique(z$Time)
  samples <- grep('M', samples, value = TRUE)
  sample<- length(samples)
  return(length(samples))
}
time(venom_data)

#This creates a list of the location of every single starting time in the data

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
M1 <- M1finder(venom_data)
as.numeric(M1[[1]])

# This function takes our starting time and total samples functions and 
#manipulates our data into a longer format where new columns that are each 
#plate location are added

long_venom <- function(csvTitle){
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

#ven <- long_venom("/Users/samklauer/Desktop/QBIO7006/210309_flourometer_readings.csv")


#This function uses the long_venom function and M1finder function in order to 
#adjust the columnn names to what we want before final tidying steps. It then using stringi 
#to remove any unwanted characters in the function.

correct_col <- function(csvTitle){
  dat <- long_venom(csvTitle)
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
  return(dat)
}

#ven <- correct_col("/Users/samklauer/Desktop/QBIO7006/210309_flourometer_readings.csv")

#This function tidies our data so that we can add the names of samples form the other data set.
#This is also where we remove all unused wells. This is done at this late step so that this code works for any 
#amount of wells used. 

Tidy_time <- function(csvTitle){
  data <- correct_col(csvTitle)
  data[2:length(data)] <- lapply(data[2:length(data)],as.numeric)
  data <- data[ , colSums(is.na(data))==0]
  data <- pivot_longer(data, !'Time', names_to = 'well position', values_to = 'value')
  data$'well position'<- gsub(x = data$'well position', pattern = " ",
                                      replacement = "")
  return(data)
}

#ven <-Tidy_time("/Users/samklauer/Desktop/QBIO7006/210309_flourometer_readings.csv")


#This function reads in the plate layout, tidies it and then unites its columns, 
#so that it can be left joint to the fluorometer readings we have tidied. This
#We then arrange it so that every datapoint from a well position is together in the
#data frame

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

Tidy_dataset <- Final_join(
  "/Users/samklauer/Desktop/QBIO7006/210309_flourometer_readings.csv",
  '/Users/samklauer/Desktop/QBIO7006/210309__Experiment_PlateLayout.xlsx'
  )  
  
