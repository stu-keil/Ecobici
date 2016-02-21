library(RCurl)

library(dplyr)
library(rgdal)

#https://www.ecobici.df.gob.mx/sites/default/files/data/usages/2015-12.csv

#Descarga automatizada de todos los archivos de viajes

year <- seq(2010,2015,1)
month <- sapply(seq(01,12,1),toString)
month <- ifelse(nchar(month) == 1, paste0("0",month), month)
merge(year,month,all=TRUE)
url <- paste0("https://www.ecobici.df.gob.mx/sites/default/files/data/usages/",merge(year,month,all=TRUE)[,1],"-",merge(year,month,all=TRUE)[,2],".csv")
destfile <- paste0(merge(year,month,all=TRUE)[,1],"-",merge(year,month,all=TRUE)[,2],".csv")
for(j in 1:length(url)) {
  download.file(url[j], destfile[j], mode="wb")
}