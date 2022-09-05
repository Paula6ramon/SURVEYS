library(janitor)
library(tibble)
library(dplyr)
library(purrr)
library(base)
test_getRegion <- function(filename,
                           sheetname,
                           icol= c(2:3),
                           irow= c(1:7)){
  df <- read_xlsx(filename, sheet= sheetname, col_names= F)
  df <- df[irow, icol]
  #df <- t(df)
  #df < row_to_names(row_number = 1)
}
                          

for(i in 1:length(filelist)){
  file<-filelist[i]
  

    df1 <- test_getRegion(filename=file,sheetname="Personal information")}


df1 <- t(df1)%>%
  row_to_names(row_number = 1)

