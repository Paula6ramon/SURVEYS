library(readxl)
library(tidyverse)
library(base)
library(dplyr)
library(tidyr)
library(xlsx)

# specifying the path for file and working directory
setwd <- ('C:/Users/PRA/OneDrive - NIVA/PROJECTS/ETC ICS/SURVEYS/SURVEYS_DATA')
filelist<-list.files(pattern= '*.xlsx')
view(filelist)

# accessing all the sheets 
sheet = excel_sheets(file)

my_data_test <- read_xlsx(setwd, 
                          file, 
                          sheet = 'Survey')%>%
  rownames_to_column() %>% 
  gather(variable, value, -rowname) %>% 
  spread(rowname, value)%>%
  select(-variable)

header=TRUE


for(i in 1:length(filelist))
  file<-filelist[i]
view(filelist)



my_data <- read.table(file='clipboard', sep='\t', header= F)%>%
  rownames_to_column() %>% 
  gather(variable, value, -rowname) %>% 
  spread(rowname, value)%>%
  select(-variable)



my_data_test <- read_xlsx(setwd, filelist[2], sheet = 'Personal information')%>%
  rownames_to_column() %>% 
  gather(variable, value, -rowname) %>% 
  spread(rowname, value)%>%
  select(-variable)


for(i in 1:length(filelist))
  file<-filelist[i]
view(filelist)

multiplesheets <- function(fname) {
  
  # getting info about all excel sheets
  sheets <- readxl::excel_sheets(fname)
  tibble <- lapply(sheets, function(x) readxl::read_excel(fname, sheet = x))
  data_frame <- lapply(tibble, as.data.frame)
  
  # assigning names to data frames
  names(data_frame) <- sheets
  
  # print data frame
  print(data_frame)
}


# specifying the path name
path <- "C:/Users/PRA/OneDrive - NIVA/PROJECTS/ETC ICS/SURVEYS/SURVEYS_DATA/Copy of Survey_EEA_climate_HN.xlsx"
df <-multiplesheets(path)
