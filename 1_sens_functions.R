library(readxl)
library(base)
library(dplyr)
library(tidyr)
library(purrr)

#------------make functions to read the files----------------------------------

datafolder <- 'C:/Users/PRA/NIVA/Therese Harvey - EEA climate change/sensitivity/responses/'
homefolder <- 'C:/Users/PRA/OneDrive - NIVA/PROJECTS/ETC ICS/SURVEYS/'
filelist<-list.files(path= datafolder)

getSensitivities<- function(filename,
                            sheetname= 'Survey',
                            icol=c(2:11), #default columns to extract from the sheet (including one for the P names)
                            irow=c(3:34), #default rows to extract from the sheet
                            ip=c(1:10), #name of the pressures (P)
                            iec=c(1:32), #name of the ecosystem components (EC)
                            gather=TRUE,
                            info=TRUE,
                            removeVals=c("Autocorrelation","x")){
  
  df <- read_excel(filename,sheet=sheetname,col_names=F)
  df <- df[irow,icol]
  names(df) <- c('EC', sprintf('P%d', ip))
  df$EC <- sprintf('EC%d', iec)
  
  
  if(gather==TRUE){
    df <- df %>%
      gather(key="P",value="Sensitivity",names(df)[2:length(names(df))])
  }
  if(info==TRUE){
    colnames<-names(df)
    df <- df %>%
      mutate(file=filelist[i],sheet=sheetname) %>%
      select(c(file,sheet,colnames))
  }
 
# 
#   df <- df %>%
#     mutate(Sensitivity=ifelse(Sensitivity %in% removeVals,NA,Sensitivity))
#   ns<-nrow(filter(df,!is.na(Sensitivity)))
#   cat(paste0(filename," [",sheetname,"] ",ns," scores\n"))
#   return(df)
}


#-------------------------- ALL FILES FUNCTION --------------------------------------

getMultiple<-function(filename){
  
  df1<-getSensitivities(filename,sheetname="Survey")
  
  for(i in 1){
    mystring <- paste0("df<-df",i) 
    eval(parse(text=mystring))
    ns<-nrow(filter(df,!is.na(Sensitivity)))
    if(ns>0){
      if(exists("df_file")){
        df_file<-bind_rows(df_file,df)
      }else{
        df_file<-df
      }
      
    }  
  }
  return(df_file)
}
