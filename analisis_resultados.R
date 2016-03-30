library(dplyr)
library(rgdal)
library(RColorBrewer)

setwd("/home/stuka/itam2/graph4ds/Ecobici/")
dir("./resultados")[grep(".csv",dir("./resultados"))]

filenames <- paste0("./resultados/",dir("./resultados")[grep(".csv",dir("./resultados"))])
titulos <- c("entre semana de 12 a 16 horas","fin de semana de 12 a 16 horas","entre semana de 16 a 21 horas","entre semana de 21  a 5 horas","entre semana de 6 a 12 horas","fin de semana de 6 a 12 horas y 16 a 24")
for(j in 1:length(filenames)){
  ecobici <- read.csv(filenames[j],header=FALSE)
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
  
  
  png(paste0(substr(filenames[j],1,nchar(filenames[j])-4),"comunidad.png"))
  plot(mask, axes=TRUE, border="gray")
  lines(calles, axes=TRUE)
  points(dat$lon, dat$lat, col=c("black"), bg=miscols,pch=mispch,  cex = 1.5)
  title(main=paste0("Detección natural de comunidades en el sistema Ecobici \n usando Analitica de Grafos \n",titulos[j]))
  dev.off()
}