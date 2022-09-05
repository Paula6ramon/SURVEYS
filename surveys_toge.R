library(readxl)
library(base)
library(dplyr)
library(tidyr)
library(tibble)

# ---------- read files  ---------------------------------
setwd('C:\\Users\\PRA\\OneDrive - NIVA\\PROJECTS\\ETC ICS\\SURVEYS')
source("test_sensitivity.R")

path <- setwd('C:\\Users\\PRA\\OneDrive - NIVA\\PROJECTS\\ETC ICS\\SURVEYS\\SURVEYS_DATA')
filelist<-list.files(pattern= 'xlsx')
view(filelist)
#apply the function to all the surveys
for(i in 1:length(filelist)){
  file<-filelist[i]
  
if(file=="Survey_EEA_climate_Baltic_SYKE_ML.xlsx")
  df <- test_getSensitivities(filename=file,sheetname="Survey")

if(file=="Survey_EEA_climate_HN.xlsx"){
  df <- test_getSensitivities(filename=file,sheetname="Survey")
  
}else if(file=="Survey_EEA_climate_Kuosa.xlsx"){
  df <- test_getSensitivities(filename=file,sheetname="Survey")
  
}else if(file=="Survey_EEA_climate_macroalgae_Baltic.xlsx"){
  df <- test_getSensitivities(filename=file,sheetname="Survey")
  
}else if(file=="Survey_EEA_climate_v7_JHA.xlsx"){
  df <- test_getSensitivities(filename=file,sheetname="Survey")
  
}else{
  df<- test_getMultiple(file)
}
if(exists("df_all")){
  df_all<-bind_rows(df_all,df)
}else{
  df_all<-df
}}

#replace classification with numbers -----
classif <- c('0: Not sensitive' = 0, '1: Low sensitivity'= 1, '2: Medium sensitivity' = 2, '3: High sensitivity' = 3 )
df_all$S <- classif[df_all$S]


#get the average

df_all2 <- df_all %>%
  filter(!is.na(S)) %>%
  mutate(P=as.numeric(substr(P,2,nchar(P))),
         EC=as.numeric(substr(EC,3,nchar(EC)))) %>%
  group_by(P,EC) %>%
  summarise(count=n(),
            Savg=round(mean(S,na.rm=T),2),
            Smed=median(S,na.rm=T))



df_med <- df_all2 %>%
  select(P,EC,S=Smed) %>%
  spread(key="EC",value="S")

df_mean <- df_all2 %>%
  select(P,EC,S=Savg) %>%
  spread(key="EC",value="S")


write.table(df_mean,file="../survey_avg_test.csv",col.names=T,row.names=F,sep=";",na="")
