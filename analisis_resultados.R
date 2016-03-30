library(dplyr)
library(rgdal)
library(RColorBrewer)



setwd("/home/stuka/itam2/graph4ds/Ecobici/")
dir("./resultados")[grep(".csv",dir("./resultados"))]

filenames <- paste0("./resultados/",dir("./resultados")[grep(".csv",dir("./resultados"))])

for(j in filenames){
  ecobici <- read.csv(j,header=FALSE)
  names(ecobici) <- c("station","community")
  
  num_tipos <- length(unique(ecobici$community))
  
  datos <- read.csv('./data/estaciones.csv')
  dat <- left_join(datos, ecobici, by = c("id" = "station"))
  pch <- c(21,22,23,24,25)
  colores <- brewer.pal(12,"Set3")
  miscols <- colores[1:num_tipos][as.factor(dat$community%%length(colores))]
  mispch <- pch[as.factor(dat$community%%length(pch))]
  
  table(ecobici$community)
  
  mask <- readOGR("./shp", "Mask_2016")
  calles <- readOGR("./shp", "Calles_2016_Mask")
  
  
  png(paste0(substr(j,1,nchar(j)-4),"comunidad.png"))
  plot(mask, axes=TRUE, border="gray")
  lines(calles, axes=TRUE)
  points(dat$lon, dat$lat, col=c("black"), bg=miscols,pch=mispch,  cex = 1.5)
  dev.off()
}