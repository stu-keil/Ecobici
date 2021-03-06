#### Este archivo transforma las variables de viajes para el analisis

library(lubridate)
library(dplyr)


rm(list = ls())
getwd()
setwd("/home/denny/github/Ecobici_denny/data/viajes/")
dir()

####Cargar 1 mes
# filename <- "2015-12.csv"
# dtype <- c("factor","numeric","numeric","numeric","character","character","numeric","character","character")
# ecobici <- read.csv(filename,header=TRUE,colClasses = dtype,na.strings = c("NA","lab009"))
# ecobici = tbl_df(ecobici)

####Cargar 2015
filename <- dir(".")[grep(".csv",dir("."))]
filename_2015 <- grep("2015",filename)
filename <- filename[filename_2015]
dtype <- c("character","character","character","character","character","character","character","character","character")
tmp <- lapply(filename,read.csv, header = TRUE, colClasses = dtype)
ecobici <- do.call(rbind,tmp)
rm(tmp)
head(ecobici)


####Genero una muestra de 1% viajes aleatorios
#ecobici <- slice(ecobici,sample(nrow(ecobici),(nrow(ecobici)*.01)))

ecobici$Fecha_hora_retiro = ymd_hms(paste(ecobici$Fecha_Retiro, ecobici$Hora_Retiro))
ecobici$Fecha_hora_arribo = ymd_hms(paste(ecobici$Fecha_Arribo, ecobici$Hora_Arribo))
ecobici <- ecobici[,c(1,2,3,4,10,7,11)]


### Cargar datos distancias cicloestaciones 
dir("..")
dtype <- c("character","character","numeric")
ecobici_distancias <- read.csv('../distancias_estaciones_metros.csv',colClasses = dtype)
names(ecobici_distancias) <- c("Estacion_origen","Estacion_destino","Distancia_metros")
glimpse(ecobici_distancias)


######## Limpieza y transformación de los datos

ecobici <- left_join(ecobici,ecobici_distancias,by=c("Ciclo_Estacion_Retiro"="Estacion_origen","Ciclo_Estacion_Arribo"="Estacion_destino"))
rm(ecobici_distancias)
ecobici <- ecobici %>% mutate(Distancia_metros = replace(Distancia_metros, Ciclo_Estacion_Retiro==Ciclo_Estacion_Arribo, 0)) %>% mutate(Distancia_km = Distancia_metros/1000.0) %>% mutate(Distancia_km = round(Distancia_km,2)) %>% select(-Distancia_metros)   


ecobici$Duracion_viaje <- hour(as.period(difftime(ecobici$Fecha_hora_arribo,ecobici$Fecha_hora_retiro),hour))*60 + minute(as.period(difftime(ecobici$Fecha_hora_arribo,ecobici$Fecha_hora_retiro),minute))
ecobici <- ecobici %>% mutate(Duracion_viaje = replace(Duracion_viaje, Duracion_viaje == 0 , 1))
ecobici <- ecobici %>% filter(!is.na(Distancia_km))


#### Exportar información a csv
#write.table(ecobici, "../../temporal/ecobici_preprocessed_2015_sample.csv", sep = ",", col.names = TRUE, row.names = FALSE)
