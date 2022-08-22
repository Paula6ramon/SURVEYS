library(readxl)
library(base)
library(dplyr)
library(tidyr)

# ---------- read files  ---------------------------------
setwd("C:/Users/PRA/OneDrive - NIVA/PROJECTS/ETC ICS/SURVEYS")
source("test_sensitivity.R")

setwd('C:\\Users\\PRA\\OneDrive - NIVA\\PROJECTS\\ETC ICS\\SURVEYS\\SURVEYS_DATA')
filelist<-list.files(pattern= 'xlsx')

#apply the function to all the surveys
for(i in 1:7:length(filelist)){
  file<-filelist[i]
  
if(file=="Survey_EEA_climate_Baltic_SYKE_ML.xlsx")
  df2 <- test_getSensitivities(filename=file,sheetname="Survey")

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
#classif <- c('0: Not sensitive' = 0, '1: Low sensitivity'= 1, '2: Medium sensitivity' = 2, '3: High sensitivity' = 3 )
df_all$S <- classif[df_all$S]


#get the average


df_all2 <- df_all %>%
  filter(!is.na(S)) %>%
  mutate(S=as.numeric(S)) %>%
  group_by(P,EC) %>%
  summarise(count=n(),Smean=mean(S,na.rm=T)) %>%
  ungroup() 

df_mean <- df_all2 %>%
  mutate(P=as.numeric(substr(P,2,nchar(P))),
         EC=as.numeric(substr(EC,3,nchar(EC)))) %>%
  group_by(P,EC) %>%
  summarise(n=n(),
            Savg=round(mean(Smean,na.rm=T),2),
            Smed=median(Smean,na.rm=T))



df_mean <- df_mean %>%
  select(P,EC,S=Savg) %>%
  spread(key="EC",value="S")

ec_order<-c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,27,19,20,21,23,24,25,26,28,29,30,31,32)
p_order <- c(1,2,3,4,5,6,7,8,9)

df_mean <- df_mean[p_order,ec_order]
df_med <- df_med[p_order,ec_order]

write.table(df_mean,file="../survey_avg_test.csv",col.names=T,row.names=F,sep=";",na="")
