#### Este archivo transforma las variables de viajes para el analisis

library(lubridate)
library(dplyr)


rm(list = ls())
getwd()
setwd("/home/stuka/itam2/graph4ds/Ecobici/Viajes/")
dir()

####Cargar 1 mes
filename <- "2015-12.csv"
dtype <- c("factor","numeric","numeric","numeric","character","character","numeric","character","character")
ecobici <- read.csv(filename,header=TRUE,colClasses = dtype,na.strings = c("NA","lab009"))
ecobici = tbl_df(ecobici)

####Genero una muestra de 100 viajes aleatorios
ecobici <- slice(ecobici,sample(nrow(ecobici),100))

ecobici$Fecha_hora_retiro = ymd_hms(paste(ymd(ecobici$Fecha_Retiro), hms(ecobici$Hora_Retiro)))
ecobici$Fecha_hora_arribo = ymd_hms(paste(ymd(ecobici$Fecha_Arribo), hms(ecobici$Hora_Arribo)))
ecobici <- ecobici[,c(1,2,3,4,10,7,11)]


### Cargar datos distancias cicloestaciones 
dir("..")
ecobici_distancias <- read.csv('../distancias_estaciones_metros.csv')
names(ecobici_distancias) <- c("Estacion_origen","Estacion_destino","Distancia_metros")
glimpse(ecobici_distancias)
rm(ecobici_distancias)

######## Limpieza y transformación de los datos

ecobici <- left_join(ecobici,ecobici_distancias,by=c("Ciclo_Estacion_Retiro"="Estacion_origen","Ciclo_Estacion_Arribo"="Estacion_destino"))
ecobici <- ecobici %>% mutate(Distancia_km = replace(Distancia_metros, Ciclo_Estacion_Retiro==Ciclo_Estacion_Arribo, 0))
ecobici <- ecobici %>% transmute(Distancia_km = )

ecobici$Duracion_viaje <- minute(as.period(difftime(ecobici$Fecha_hora_arribo,ecobici$Fecha_hora_retiro),minute))

#### Exportar información a csv
write.table(ecobici, "../temporal/ecobici_preprocessed.csv", sep = ",", col.names = TRUE, row.names = FALSE)
