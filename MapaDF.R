install.packages('devtools')
install.packages('rgdal')
install.packages('shiny')
devtools::install_github("hrbrmstr/asam")
install.packages(c('leaflet','sp','dplyr'))
install.packages('rjson')
install.packages("RCurl")
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




getwd()
setwd("/itam2/")
setwd("../.././shp/")
dir("../")
####Mapa

datos <- read.csv('../estaciones.csv')
glimpse(datos)
#class(datos$latitud)
#class(datos$longitud)
#datos[,7:8]
glimpse(datos)

which(sort(datos$id)[1:444]-sort(datos$id)[2:445]!=-1)
sort(datos$id)
##No existen las estaciones 103 y 111

# dat <- subset(asam_shp,
#               DateOfOcc > as.Date("2015-01-01") &
#                 grepl("pirate", Aggressor, ignore.case=TRUE))
# could also do data.frame(dat)

dat <- bind_cols(filter(datos, lat= !is.na(lat), lon =  !is.na(lon)))

writeOGR()


getwd()
setwd("../.././shp/")
dir("./shp")[grep("*.shp",dir("./shp"))]
shape <- readShapePoints("./shp/.shp")
mask <- readOGR("./shp", "Mask_2016")
colonias <- readOGR("./shp", "ColoniasDF")
calles <- readOGR("./shp", "Calles_2016_Mask")
print(proj4string(colonias))
plot(colonias, axes=TRUE, border="gray")
??readOGR


str(colonias)


coords = cbind(dat$lon, dat$lat)
sp = SpatialPoints(coords)
spdf = ?SpatialPointsDataFrame(coords, dat)
coordinates(dat) = ~dat$longitud + dat$latitud
points(dat$longitud, dat$latitud, col = dat$delegacion, cex = .6)
head(colonias@data)
unique(colonias@data$MUN_NAME)
length(colonias@data$MUN_NAME)
coloniasecobici = colonias[which(colonias@data$MUN_NAME %in% c("CUAUHTÉMOC","MIGUEL HIDALGO")),]
plot(colonias)
plot(mask, axes=TRUE, border="gray")
lines(calles, axes=TRUE)
points(dat$lon, dat$lat, col =c("red"),pch=19,  cex = 0.5)
legend('bottomleft', legend = c("Estaciones a 2016") , 
       pch=19, col=c("red"), cex=1)



legend('bottomleft', legend = c("Perifericas","Trafico Local","Enlaces Urbanos","Zonas de Trabajo") , 
       pch=19, col=c("red","blue","green","orange"), cex=1)
colores <- c("red","blue","green","orange","purple","yellow","black","grey")
miscols <- colores[as.factor(prueba$clusters)]

??pch
prueba <- left_join(dat, matriz, by =c("id"="estacion"))
View(prueba)

