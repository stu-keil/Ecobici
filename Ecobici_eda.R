# Caracterización de las cicloestaciones del programa Ecobici
# Una implementación del Algoritmo EM
# 
# Estadística Computacional - Profesor Mauricio García Tec
# 
# Denisse Martínez	159780 
# Ariana López             160281
# Stephane Keil		160559
install.packages("lubridate")
install.packages("ggplot2")
install.packages("GGally")
library(dplyr)
library(ggplot2)
library(GGally)
library(foreign)
library(mvtnorm)
library(lubridate)
library(dplyr)
library(mixtools)
library(rgdal)
library()

rm(list = ls())
getwd()
setwd("/home/stuka/itam2/graph4ds/Ecobici/Viajes/")
dir()

####Cargar 1 mes
filename <- "2015-12.csv"
dtype <- c("factor","numeric","numeric","numeric","character","character","numeric","character","character")
ecobici <- read.csv(filename,header=TRUE,colClasses = dtype,na.strings = c("NA","lab009"))
?read.csv
names(ecobici)
dim(ecobici)
ecobici = tbl_df(ecobici)
glimpse(ecobici)
summary(ecobici)
head(ecobici)
tail(ecobici)
for 
  plot(ecobici[[5]])
hist(ecobici[[5]])
hist(as.numeric(ecobici[[5]]))
View(ecobici)


ecobici[[5]] <- ymd(ecobici[[5]])
ecobici[[8]] <- ymd(ecobici[[8]])
ecobici[[6]]<- hms(ecobici[[6]])
ecobici[[9]]<- hms(ecobici[[9]])
str(ecobici)
second(ecobici[[9]])
wday(ecobici[[8]])


#####Cargar 1 año 2012
#setwd("C:/Users/Stephane/Desktop/ITAM/EstadisticaComputacional/Proyecto_Final/Datos/2012")
filename <- dir(".")[grep(".csv",dir("."))]
filename_2015 <- grep("2015",filename)
filename <- filename[filename_2015]
#dtype <- c("factor","numeric","numeric","numeric","character","character","numeric","character","character")
dtype <- c("character","character","character","character","character","character","character","character","character")
tmp <- lapply(filename,read.csv, header = TRUE, colClasses = dtype)
ecobici <- do.call(rbind,tmp)
rm(tmp)
head(ecobici)

which(!ecobici$Genero_Usuario %in% c("M","F"))
ecobici$Genero_Usuario <- as.factor(ecobici$Genero_Usuario)


ecobici$Edad_Usuario <- as.numeric(ecobici$Edad_Usuario)

is.numeric(ecobici$Ciclo_Estacion_Retiro)

sort(as.numeric(unique(ecobici$Ciclo_Estacion_Retiro)))

ecobici$Ciclo_Estacion_Retiro <- as.numeric(ecobici$Ciclo_Estacion_A)

sort(as.numeric(unique(ecobici$Ciclo_Estacion_Arribo)))
ecobici$Ciclo_Estacion_Arribo <- as.numeric(ecobici$Ciclo_Estacion_Arribo)

describe(ecobici)

summary(ecobici)
hist(unclass(ecobici$Genero_Usuario))
ecobici[which(ecobici$Edad_Usuario > 80),]
head(ecobici)

count(ecobici)
#9192076
table(ecobici$Genero_Usuario)/nrow(ecobici)

table(ecobici$Edad_Usuario)/nrow(ecobici)*100



######Analisis exploratorio
ggpairs(ecobici,columns=1:ncol(ecobici))


plot(table(day(ecobici$Fecha_Retiro)), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici entre semana",xaxt="n")
axis(side = 1, at = seq(min(day(ecobici$Fecha_Retiro)),max(day(ecobici$Fecha_Retiro)),1))

plot(table(week(ecobici$Fecha_Retiro)), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici entre semana",xaxt="n")
axis(side = 1, at = seq(min(week(ecobici$Fecha_Retiro)),max(week(ecobici$Fecha_Retiro)),1))

plot(table(month(ecobici$Fecha_Retiro)), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici entre semana",xaxt="n")
axis(side = 1, at = seq(min(month(ecobici$Fecha_Retiro)),max(month(ecobici$Fecha_Retiro)),1))


plot(table(wday(ecobici$Fecha_Retiro)), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici entre semana",xaxt="n")
axis(side = 1, at = seq(min(wday(ecobici$Fecha_Retiro)),max(wday(ecobici$Fecha_Retiro)),1))

hist(wday(ecobici$Fecha_Retiro), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici entre semana")
axis(side = 1, at = seq(min(wday(ecobici$Fecha_Retiro)),max(wday(ecobici$Fecha_Retiro)),1))

table(wday(ecobici$Fecha_Retiro))

par(mfrow=c(2,2))
plot(table(hour(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) %in% c(2:6))])+minute(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) %in% c(2:6))])/60), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici entre semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))
plot(table(hour(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) %in% c(1,7))])+minute(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) %in% c(1,7))])/60), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici en fines de semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))
plot(table(hour(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) %in% c(2:6))])+minute(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) %in% c(2:6))])/60), xlab="Horario", ylab="Viajes",main="Horarios de llegadas de Ecobici entre semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))
plot(table(hour(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) %in% c(1,7))])+minute(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) %in% c(1,7))])/60), xlab="Horario", ylab="Viajes",main="Horarios de llegadas de Ecobici en fin de semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))


plot(table(hour(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == 1)])+minute(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == 1)])/60), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici entre semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))
plot(table(hour(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == 2)])+minute(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == 2)])/60), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici en fines de semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))
plot(table(hour(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == 3)])+minute(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == 3)])/60), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici en fines de semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))
plot(table(hour(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == 4)])+minute(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == 4)])/60), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici en fines de semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))
plot(table(hour(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) == 1)])+minute(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) ==1)])/60), xlab="Horario", ylab="Viajes",main="Horarios de llegadas de Ecobici entre semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))
plot(table(hour(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) == 2)])+minute(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) ==2)])/60), xlab="Horario", ylab="Viajes",main="Horarios de llegadas de Ecobici en fin de semana",xaxt="n")
axis(side = 1, at = seq(0,24,2))


par(mfrow=c(4,2))
for(i in min(wday(ecobici$Fecha_Retiro)):max(wday(ecobici$Fecha_Retiro))){
  plot(table(hour(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == i)])+minute(ecobici$Hora_Retiro[which(wday(ecobici$Fecha_Retiro) == i)])/60), xlab="Horario", ylab="Viajes",main="Horarios de salidas de Ecobici entre semana",xaxt="n")
  axis(side = 1, at = seq(0,24,2))
}

par(mfrow=c(1,1))
hist(quarter(ecobici$Fecha_Retiro))

par(mfrow=c(4,2))
for(i in min(wday(ecobici$Fecha_Retiro)):max(wday(ecobici$Fecha_Retiro))){
  plot(table(hour(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) == i)])+minute(ecobici$Hora_Arribo[which(wday(ecobici$Fecha_Arribo) ==i)])/60), xlab="Horario", ylab="Viajes",main="Horarios de llegadas de Ecobici entre semana",xaxt="n")
  axis(side = 1, at = seq(0,24,2))
}

table(wday(ecobici$Fecha_Retiro))
table(day(ecobici$Fecha_Retiro))
table(hour(ecobici$Hora_Retiro),month(ecobici$Fecha_Retiro))


length(day(ecobici$Fecha_Retiro))/length(unique(day(ecobici$Fecha_Retiro)))
length(day(ecobici$Fecha_Retiro[which(wday(ecobici$Fecha_Retiro) %in% c(2:6))]))/length(unique(day(ecobici$Fecha_Retiro[which(wday(ecobici$Fecha_Retiro) %in% c(2:6))])))
length(day(ecobici$Fecha_Retiro[which(wday(ecobici$Fecha_Retiro) %in% c(1,7))]))/length(unique(day(ecobici$Fecha_Retiro[which(wday(ecobici$Fecha_Retiro) %in% c(1,7))])))

length(week(ecobici$Fecha_Retiro))/length(unique(week(ecobici$Fecha_Retiro)))

table(month(ecobici$Fecha_Retiro))

table(wday(ecobici$Fecha_Retiro))/table(wday(unique(ecobici$Fecha_Retiro)))

table(day(ecobici$Fecha_Retiro))/table(day(unique(ecobici$Fecha_Retiro)))


"Viajes diarios por semana"
table(week(ecobici$Fecha_Retiro))/table(week(unique(ecobici$Fecha_Retiro)))

countwd <- function(startdate=min(ecobici$Fecha_Retiro), enddate=max(ecobici$Fecha_Retiro), weekday){
  x <- seq( startdate, enddate, by=1 )
  y <- wday( x )
  table(y)
  sum( y == weekday )
}
countwd(min(ecobici$Fecha_Retiro),max(ecobici$Fecha_Retiro),"")
str(salidas) 
  par(mfrow=c(1,1))
########Limpieza y transformación de los datos

ecobici_distancias <- read.csv('../../ecobici_distancias.csv')
a <- cbind((ecobici_distancias$EstacionD),(ecobici_distancias$EstacionO),ecobici_distancias$Distancia)
colnames(a) <- c("EstacionO","EstacionD","Distancia")
b <- rbind(a,ecobici_distancias)

ecobici <- left_join(ecobici,b,by=c("Ciclo_Estacion_Retiro"="EstacionO","Ciclo_Estacion_Arribo"="EstacionD"))
ecobici[which(ecobici$Ciclo_Estacion_Retiro==ecobici$Ciclo_Estacion_Arribo),]$Distancia <- 0

rm(a,b,ecobici_distancias,column.dt)
ecobici["258210",]#Juanito
#### Set times 
ecobici$date_retiro <- ymd_hms(paste(ecobici[[5]],ecobici[[6]]))
ecobici$date_arribo <- ymd_hms(paste(ecobici[[8]],ecobici[[9]]))
ecobici <- ecobici[which(complete.cases(ecobici)),]
ecobici$dur_via <- minute(as.period(difftime(ecobici$date_arribo,ecobici$date_retiro),minute))

ecobici <- ecobici[which(ecobici$Ciclo_Estacion_Retiro<500),]

hist(ecobici$dur_via,breaks = 100,main="Duración Promedio de Viajes",xlab="Duración en minutos",ylab="Frecuencia")
hist(ecobici$Distancia,breaks = 100,main="Distancia Promedio de Viajes",xlab="Distancia en kilometros",ylab="Frecuencia",xaxt="n")
axis(side = 1, at = seq(0,15,1))

summary(ecobici$dur_via)
head(ecobici)
########################
#### construccion de variables de analisis###

#Edad promedio por estacion
estacion.edad <- data.frame(rbind(cbind(ecobici$Edad_Usuario,ecobici$Ciclo_Estacion_Retiro),cbind(ecobici$Edad_Usuario,ecobici$Ciclo_Estacion_Arribo)))
colnames(estacion.edad)<-c("EdadUsuario","EstacionNum")
estacion.edad.avg <- estacion.edad %>% group_by(EstacionNum)%>% summarise(edades=mean(EdadUsuario))
glimpse(estacion.edad.avg)

plot(estacion.edad.avg$edades,estacion.edad.avg$EstacionNum, type="p", main="Edad Promedio del Usuario por Cicloestacion",col="blue",xlab="Edad promedio", ylab="Num Cicloestacion")
hist(estacion.edad.avg$edades,breaks=50,main = "Edad promedio Usuarios Ecobici", col="blue", border="gray", xlab="Edad promedio", ylab="Frecuencia")
plot(density(estacion.edad.avg$edades),main = "Edad promedio Usuarios Ecobici", col="blue", border="gray", xlab="Edad promedio", ylab="Densidad")

columns[["age"]] <- estacion.edad.avg
#F=1

#Proporcion de mujeres-hombres que usan las estaciones
estacion.genero <- data.frame(rbind(cbind(ecobici$Genero_Usuario,ecobici$Ciclo_Estacion_Retiro),cbind(ecobici$Genero_Usuario,ecobici$Ciclo_Estacion_Arribo)))
colnames(estacion.genero)<-c("GeneroUsuario","EstacionNum")

estacion.splt.gen <-data.frame(table(estacion.genero$GeneroUsuario,estacion.genero$EstacionNum))
colnames(estacion.splt.gen)<-c("GeneroUsuario","EstacionNum","CountGen")
head(estacion.splt.gen)
estacion.genero.all <- estacion.splt.gen %>% group_by(EstacionNum)%>% summarise(CountGen=sum(CountGen))
head(estacion.genero.all)
estacion.splt.gen <- left_join(estacion.splt.gen,estacion.genero.all,by=c("EstacionNum"="EstacionNum"))
estacion.splt.gen[["prop"]] <- estacion.splt.gen$CountGen.x/estacion.splt.gen$CountGen.y

sex <- estacion.splt.gen[which(estacion.splt.gen$GeneroUsuario==1),]
sex <- sex[,c(2,5)]
sex$EstacionNum <- as.numeric(as.character(sex$EstacionNum))
columns[["sex"]] <- sex


hist(sex$prop,main = "Proporción promedio de mujeres Usuarias Ecobici por cicloestación", breaks=50, col="black",  xlab="Proporción promedio de mujeres", ylab="Frecuencia")

#######

head(ecobici)

###Construccion de las variables de analisis
columns <- list()
columns[["sal_mor"]] <- ecobici %>% filter(wday(date_retiro)%in% c(2:6) & hour(date_retiro)%in% c(6:11)) %>%  group_by(Ciclo_Estacion_Retiro) %>% summarise(sal_mor=n())
columns[["lleg_mor"]] <- ecobici %>% filter(wday(date_retiro)%in% c(2:6) & hour(date_retiro)%in% c(6:11)) %>%  group_by(Ciclo_Estacion_Arribo) %>% summarise(lleg_mor=n())
columns[["sal_mid"]] <- ecobici %>% filter(wday(date_retiro)%in% c(2:6) & hour(date_retiro)%in% c(12:16)) %>%  group_by(Ciclo_Estacion_Retiro) %>% summarise(sal_mid=n())
columns[["lleg_mid"]] <- ecobici %>% filter(wday(date_retiro)%in% c(2:6) & hour(date_retiro)%in% c(12:16)) %>%  group_by(Ciclo_Estacion_Arribo) %>% summarise(lleg_mid=n())
columns[["sal_tar"]] <- ecobici %>% filter(wday(date_retiro)%in% c(2:6) & hour(date_retiro)%in% c(17:20)) %>%  group_by(Ciclo_Estacion_Retiro) %>% summarise(sal_tar=n())
columns[["lleg_tar"]] <- ecobici %>% filter(wday(date_retiro)%in% c(2:6) & hour(date_retiro)%in% c(17:20)) %>%  group_by(Ciclo_Estacion_Arribo) %>% summarise(lleg_tar=n())
columns[["sal_noc"]] <- ecobici %>% filter(wday(date_retiro)%in% c(2:6) & hour(date_retiro)%in% c(21:24,0:5)) %>%  group_by(Ciclo_Estacion_Retiro) %>% summarise(sal_noc=n())
columns[["lleg_noc"]] <- ecobici %>% filter(wday(date_retiro)%in% c(2:6) & hour(date_retiro)%in% c(21:24,0:5)) %>%  group_by(Ciclo_Estacion_Arribo) %>% summarise(lleg_noc=n())
columns[["dist"]] <- ecobici %>% group_by(Ciclo_Estacion_Arribo) %>% summarise(distancia=mean(Distancia))
columns[["dur_via"]] <- ecobici %>% group_by(Ciclo_Estacion_Arribo) %>% summarise(dur_via=mean(dur_via))

#### Integración de las variables de analisis


matriz <-data.frame(sort(unique(c(ecobici$Ciclo_Estacion_Retiro,ecobici$Ciclo_Estacion_Arribo))))
names(matriz) <- "estacion"

for(i in 1:length(columns)){
  print(i)
  matriz <- left_join(matriz, columns[[i]], by =c("estacion"=names(columns[[i]])[1]))
}

summary(matriz)
par(mfrow=c(3,4))
for(i in 2:ncol(matriz)){
  hist(matriz[[i]],main=paste0("Histograma de ",names(matriz)[i]),col="black",breaks=50,xlab=names(matriz)[i])
}

write.csv(matriz,'../../matriz_disenio_2012.csv',row.names = FALSE)



par(mfrow=c(1,1))
pairs(matriz)


#########K means - para determinar numero optimo de clusters y comparar con EM
data <- matriz[,c(1:ncol(matriz))]

model <- kmeans(data,8)

colores <- c("red","blue","green","orange","purple","yellow","black","grey")
miscols <- colores[model$cluster]
model

matriz[["clusters"]] <- model$cluster

wssplot <- function(data, nc=15, seed=25051982){
  wss <- (nrow(data)-1)*sum(apply(data,2,var))#Caclula la varianza del conjunto completo
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(data, centers=i)$withinss)}##Por cada #clusters calcula la varianza intra cluster
  plot(1:nc, wss, type="b", xlab="Numero de Grupos",
       ylab="Suma de CUadrados Intra-Cluster",main="Selección del numero de clusters")}
wssplot(data)

aggregate(data, by=list(cluster=model$cluster), mean)

###Algoritmo EM
########### N clusters N atributos
library(mvtnorm)

x <- x[complete.cases(x),]
summary(x)
plot(x)

#### Aplicación de PCA para reducción de la dimensionalidad

rdata.pca <- prcomp(data,center = TRUE,scale. = TRUE)
summary(rdata.pca)
str(rdata.pca)
rdata.pca$rotation
#PC1,PC2,PC3 explican 82%

#MIS variables transformadas PC1,PC2,PC3 que explican el 82% varianza
x <- rdata.pca$x
x <- as.data.frame(x[,1:2])

#### Incialización aleatoria de los parametros o variables latentes
initialize <- function(n_clusters,data){
  theta <- list(tau=rep(1/n_clusters,n_clusters))
  for(i in 1:n_clusters){
    for(j in 1:ncol(data)){
      theta[[paste0("mu",i)]] <- c(theta[[paste0("mu",i)]],runif(1,min(data[,j]),max(data[,j])))
    }
  }
  for(i in 1:n_clusters){
    arr <- numeric()
    for(j in 1:ncol(data)){
      for(k in 1:ncol(data)){
        if(j==k){
          arr <- c(arr,runif(1,0,var(data[,k])))
        }
        else{
          arr <- c(arr,0)
        }
      }
    }
    theta[[paste0("sigma",i)]] <- matrix(arr,ncol=ncol(x))
  }
  return(list=theta)
}

#E step: calcula variables condicionales para variables latentes
E.step <- function(theta){
  temp <- numeric(0)
  for(i in 1:length(theta$tau)){
    temp <- cbind(temp,theta$tau[i] * mvtnorm::dmvnorm(x,mean=theta[[paste0("mu",i)]],sigma=theta[[paste0("sigma",i)]]))
  }
  T <- t(apply(temp,1,function(x) x/sum(x)))
  return(T)
}
#M step: Calcula los parametros que maximizan la función Q
M.step <- function(T){
  result <- list(tau=apply(T,2,mean))
  for(i in 1:n_clusters){
    result[[paste0("mu",i)]] <- apply(x,2,weighted.mean,T[,i])
  }
  for(i in 1:n_clusters){
    result[[paste0("sigma",i)]] <- cov.wt(x,T[,i])$cov
  }
  return(result)
} 

#### Ejemplo de Prueba

xpts <- seq(from=round(min(x[,1]),0),to=round(max(x[,1]),0),length.out=100)
ypts <- seq(from=round(min(x[,2]),0),to=round(max(x[,2]),0),length.out=100)
plot.em <- function(theta){
  mixture.contour <- outer(xpts,ypts,function(x,y) {
    theta$tau[1]*mvtnorm::dmvnorm(cbind(x,y),mean=theta$mu1,sigma=theta$sigma1) + theta$tau[2]*mvtnorm::dmvnorm(cbind(x,y),mean=theta$mu2,sigma=theta$sigma2) +theta$tau[3]*mvtnorm::dmvnorm(cbind(x,y),mean=theta$mu3,sigma=theta$sigma3)+theta$tau[4]*mvtnorm::dmvnorm(cbind(x,y),mean=theta$mu4,sigma=theta$sigma4)
  })
  contour(xpts,ypts,mixture.contour,nlevels=5,drawlabel=FALSE,col="red",xlab="X",ylab="Y")
  points(x)
}
 


#### Algoritmo EM
n_clusters <- 4 
theta <- initialize(n_clusters,x)
iter <- 0
png(filename=paste("em",formatC(iter,width=4,flag="0"),".png",sep=""))
plot.em(theta)
dev.off()
#run EM and plot
for (iter in 1:30){
  print(paste0("Iteracion: ",iter))
  T <- E.step(theta)
  theta <- M.step(T)
  png(filename=paste("em",formatC(iter,width=4,flag="0"),".png",sep=""))
  plot.em(theta)
  dev.off()
}
theta


clusters <- function(T){
  return(apply(T,1,which.max))
}
centers <- function(theta){
  centers <- numeric(0)
  for(i in 1:n_clusters){
   centers<-  rbind(centers,theta[[paste0("mu",i)]]) 
  }
  return(centers)
}

###Cluster Labeling
matriz <- matriz[which(complete.cases(matriz)),]
matriz[["clusters"]] <- clusters(T)
centers <- centers(theta)



#### Cluster characterization
aggregate(data, by=list(cluster=matriz$cluster), mean)
aggregate(data, by=list(cluster=matriz$cluster), length)
aggregate(data, by=list(cluster=matriz$cluster), sd)
aggregate(data, by=list(cluster=rep(1,nrow(data))), mean)
aggregate(data, by=list(cluster=rep(1,nrow(data))), sd)


#### Cluster visualization
pairs(matriz[-ncol(matriz)],col=miscols)
par(mfrow=c(2,3))
plot(matriz$estacion,matriz$distancia,col=miscols,pch=19,xlab="# Estación",ylab="Distancia promedio")
plot(matriz$estacion,matriz$prop,col=miscols,pch=19,xlab="# Estación",ylab="% viajes por mujeres")
plot(matriz$sal_mor,matriz$lleg_mor,col=miscols,pch=19,xlab="Salidas Mañana",ylab="Llegadas Mañana")
plot(matriz$sal_tar,matriz$lleg_tar,col=miscols,pch=19,xlab="Salidas Tarde",ylab="Llegadas Tarde")
plot(matriz$dur_via,matriz$sal_tar,col=miscols,pch=19,xlab="Duración viajes",ylab="Salidas Tarde")

#### Visualización de Mapas

getwd()
setwd("../.././shp/")
dir()
shape <- readShapePoints("./shp/.shp")
mask <- readOGR(".", "Mask")
calles <- readOGR(".", "CallesMask")

dat <- bind_cols(filter(datos, latitud= !is.na(latitud), longitud =  !is.na(longitud)))
prueba <- left_join(dat, matriz, by =c("id"="estacion"))
colores <- c("red","blue","green","orange","purple","yellow","black","grey")
miscols <- colores[as.factor(prueba$clusters)]

plot(mask, axes=TRUE, border="gray")
lines(calles, axes=TRUE)
points(prueba$longitud, prueba$latitud, col =miscols,pch=19,  cex = 1.5)
legend('bottomleft', legend = c("Perifericas","Trafico Local","Enlaces Urbanos","Zonas de Trabajo") , 
       pch=19, col=c("red","blue","green","orange"), cex=1)

