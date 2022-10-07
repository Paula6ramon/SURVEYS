library(janitor)
library(tibble)
library(dplyr)
library(purrr)
library(base)

getRegion <- function(filename,
                      sheetname= 'Personal information',
                      icol= c(2:3),
                      irow= c(1:7),
                      info=TRUE){
  dr <- read_xlsx(filename, sheet= sheetname, col_names= F)
  dr <- dr[irow, icol]
  dr <- t(dr)%>%
    row_to_names(row_number=1)

  if(info==TRUE){
      dr <- as.data.frame(dr)
      colnames <- names(dr)
      dr <- dr%>%
      mutate(file=filelist[i],sheet=sheetname) %>%
      select(c(file,sheet,colnames))
      } 
  }

for(i in 1:length(filelist)){
  filename <- paste(datafolder,filelist[i], sep='')
  dr <-  getRegion(filename)
}

getAllRegions<-function(filename){
  
  dr1<-getRegion(filename)
  
  for(i in 1){
    mystring <- paste0("dr<-dr",i) 
    eval(parse(text=mystring))
    if(exists("dr_file")){
        dr_file<-bind_rows(dr_file,dr)
      }else{
        dr_file<-dr
      }
      
    }  
  return(dr_file)
}

for (i in 1:length(filelist)){
  filename <- paste(datafolder,filelist[i], sep='')
  dr <- getAllRegions(filename)
  
  if(exists("dr_all")){
    dr_all<-bind_rows(dr_all,dr)
  }else{
    dr_all<-dr
  }}

df_all <- dr_all%>%
  select(file,`Selected Regional Sea/Seas`)%>%
  left_join(df_all, dr_all, by= 'file')

#replace classification with numbers -----
classif <- c('0: Not sensitive' = 0, '1: Low sensitivity'= 1, '2: Medium sensitivity' = 2, '3: High sensitivity' = 3 )
df_all$Sensitivity <- classif[df_all$Sensitivity]

#-------separate them by the regional sea--------
colnames(df_all)[2] <- 'Regional sea'
df_all <-df_all%>%
  filter(!is.na(Sensitivity))%>%
  mutate(P=as.numeric(substr(P,2,nchar(P))), 
         EC=as.numeric(substr(EC, 3, nchar(EC))))
  
#get the average

df_all2 <- df_all%>%
  group_by(`Regional sea`,P,EC) %>%
  summarise(count=n(),
            Smean=round(mean(Sensitivity,na.rm=T),2),
            Smedian=median(Sensitivity,na.rm=T))

test<- df_all2%>%
  split(.$`Regional sea`)


regnames <- paste('stats/', names(test[i]), sep='')
for (i in 1:length(test)) {
  regnames[i] <- paste('stats/', names(test[i]), sep='')
}

for (i in 1:length(test)) {
  write.csv(test[[i]], file= paste(regnames[i],'stats.csv', sep='_'), row.names= F)
}


statslist <- list.files(paste0(homefolder, 'stats'))

getMed <- function(filename){
  dt <- read.csv(paste0('stats/',filename), header=T, sep=',')
  
  df_med <- dt%>%
    select(P, EC, Smedian)%>%
    spread(key='EC', value='Smedian')
}
getMean <- function(filename){
  dt <- read.csv(paste0('stats/',filename), header=T, sep=',')
  
  df_mean <- dt%>%
    select(P, EC, Smean)%>%
    spread(key='EC', value = 'Smean')
    
}

#----------------------------GET THE MEDIAN------------------------------------
med <-map(statslist,getMed)
names(med) <- c('Baltic Sea_med', 'Black Sea_med', 'Mediterranean Sea_med', 'North East Atlantic_med')

for (i in 1:length(med)){
  write.csv(med[[i]], file= paste0('stats/',names(med[i]), '.csv'),  row.names = F)
}

#-----------------------------GET THE MEAN-------------------------------------

mean <-map(statslist,getMean)
names(mean) <- c('Baltic Sea_mean', 'Black Sea_mean', 'Mediterranean Sea_mean', 'North East Atlantic_mean')

for (i in 1:length(mean)){
  write.csv(mean[[i]], file= paste0('stats/',names(mean[i]), '.csv'), row.names = F)
}
