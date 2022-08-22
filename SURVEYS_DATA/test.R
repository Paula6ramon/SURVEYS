library(base)
Copy_of_Survey_EEA_climate_HN <- read_excel("SURVEYS_DATA/Copy of Survey_EEA_climate_HN.xlsx", 
                                            sheet = "Survey")
test_file <- Copy_of_Survey_EEA_climate_HN
test_getSensitivities<- function(filename= 'Copy_of_Survey_EEA_climate_HN',
                                 sheetname= 'Survey',
                                 icol=c(2:12), #default columns to extract from the sheet (including one for the P names)
                                 irow=c(3:33), #default rows to extract from the sheet
                                 ip=c(1:10), #name of the pressures (P)
                                 iec=c(1:31), #name of the ecosystem components (EC)
                                 gather=TRUE,
                                 info=TRUE)
  

df <- read_xlsx(Copy_of_Survey_EEA_climate_HN,sheet='Survey',col_names=F)
df <- df[irow,icol]
names(df)<-c("P",sprintf("EC%d",iec))
df$P<-sprintf("P%d",ip)
view(df)


library(xlsx)
# first example subset; call it ss1
# assume first row is not a header; otherwise requires header = T
filelist<-list.files()
file<-filelist[i]
surv1 <- read.xlsx(Copy_of_Survey_EEA_climate_HN, sheetName = 'Survey', rowIndex = 3:33, colIndex = 4:61)
View(surv1)