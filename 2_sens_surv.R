library(readxl)
library(tidyverse)

source("1_sens_functions.R")
#--------------------------APPLY SENSITIVITY FUNCTION-------------------------------------
for(i in 1:length(filelist)){
  filename <- paste(datafolder,filelist[i], sep='')
  df <- getSensitivities(filename, 'Survey')
}

#try<- map(filelist,getSensitivities, datafolder)
#with the previous function we get the scores on the console, but we need it
#as a data frame.


#--------------------------APPLY MULTIPLE FUNCTION-------------------------------------
for (i in 1:length(filelist)){
  filename <- paste(datafolder,filelist[i], sep='')
  df <- getMultiple(filename)
  
  if(exists("df_all")){
    df_all<-bind_rows(df_all,df)
  }else{
    df_all<-df
  }}





