##################### DEPA 2 #####################
# En los siguientes sitios web aparecer�n tablas de remuneraciones de distintas instituciones
# pertenecientes al sector p�blico.

    # https://www.portaltransparencia.cl/PortalPdT/pdtta/-/ta/AV001/PR/PCONT/15762429
    # https://www.uaf.cl/transparencia/2012/per_remuneraciones_ene-nov.html
    # http://www.gorearaucania.cl/transparencia/2018/remuneraciones.html

#   Se le pide que extraiga esta informaci�n y realice la estad�stica pertinente respondiendo a
# alguna pregunta que usted se haga viendo los datos de estos sitios. En su an�lisis, debe al
# menos mostrar dos gr�ficos. 

#####################        #####################


#Para la realizaci�n de este ejercicios, se utilizaron las librerias "Xml12" y "Rvest", para analisis de Html
# y "ggplot2" para graficar resultados.



rm(list=ls())

install.packages("rvest")

library(xml2)
library(rvest)
library(ggplot2)


####################### PASO 1 #######################
#        EXTRACCI�N Y VISUALIZACI�N DE DATA           #


#Asignamos las variables HTML para su exploraci�n y extracci�n,
# para ello se utiliz� el comando read_html() y view()

HtmlExCNA <- read_html("https://www.portaltransparencia.cl/PortalPdT/pdtta/-/ta/AV001/PR/PCONT/15762429")
HtmlINDAP <- read_html("https://www.portaltransparencia.cl/PortalPdT/pdtta/-/ta/AR004/PR/PCONT/52470664")
HtmlGobRArauco <- read_html("http://www.gorearaucania.cl/transparencia/2018/remuneraciones.html")


#Visualizaci�n de elementos dentro del Html

View(HtmlExCNA) 
View(HtmlINDAP)
View(HtmlGobRArauco)


# A continuaci�n se extraen las tablas de los links
# se utilizaron los comandos Html_Table (), para extracci�n directa
# y html_node para extracci�n con nodos.

#EXTRACCI�N DIRECTA

  # Extracci�n Ex CNC
TablaExCNA <- html_table(HtmlExCNA)  
print(TablaExCNA)
TablaLimpia1 <- TablaExCNA[[1]]
View(TablaLimpia1)
str(TablaLimpia1)
  
  #Extracci�n INDAP
TablaINDAP <- html_table(HtmlINDAP)
print(TablaINDAP)
TablaLimpia2 <- TablaINDAP[[1]]
View(TablaLimpia2)
str(TablaLimpia2)

#EXTRACCI�N CON NODES

  #Extracci�n UNAF
TablaRemu <- html_node(HtmlGobRArauco, "#remuneraciones > table")
print(TablaRemu)
tablaleida <- html_table(TablaRemu)
View(tablaleida)
str(tablaleida)

  # Se destaca la existencia de ruido en esta tabla


####################### PASO 2 #######################
#   VISUALIZACI�N, LIMPIEZA Y RESPALDO DE TABLAS     #


#La tabla extraida de UNAF presenta ruido, por lo que se procede a limpiarle,
# eliminando columnas con valores N/A,  fila con ruido y renombraron las columnas con valores "Xn"
# El resto de las tablas no present� ruido


  #Se identificaron los nombres de columnas, para ser reemplazados. Se utiliz� colnames() para identificar columnas,
# y names() para asignar la posici�n a reemplazar.

colnames(tablaleida)

names(tablaleida)[names(tablaleida) == "X1"] <- "Estamento"
names(tablaleida)[names(tablaleida) == "X2"] <- "Grado"
names(tablaleida)[names(tablaleida) == "X3"] <- "Unidad Monetaria"
names(tablaleida)[names(tablaleida) == "X4"] <- "Sueldo Base"
names(tablaleida)[names(tablaleida) == "X5"] <- "Incremento DL 3.501.art.2"
names(tablaleida)[names(tablaleida) == "X6"] <- "Asignaci�n Responsabilidad Superior DL 1770/77"
names(tablaleida)[names(tablaleida) == "X7"] <- "Asignaci�n Profesional Ley 19.185 Art.19"
names(tablaleida)[names(tablaleida) == "X8"] <- "Asignaci�n Sustitutiva Ley 19.185 Art 18�"
names(tablaleida)[names(tablaleida) == "X9"] <- "Bonificaci�n Ley 18.566 art. 3�"
names(tablaleida)[names(tablaleida) == "X10"] <- "Asignaci�n Compensatoria Ley    N�18.675 Art N� 10"
names(tablaleida)[names(tablaleida) == "X11"] <- "Gastos de Representaci�n DL    773/74"
names(tablaleida)[names(tablaleida) == "X12"] <- "A. de Zona"
names(tablaleida)[names(tablaleida) == "X13"] <- "Asignaci�n de Modernizaci�n Ley 19.553"
names(tablaleida)[names(tablaleida) == "X14"] <- "Asig funci�n Cr�tica"
names(tablaleida)[names(tablaleida) == "X15"] <- "Total Remuneraci�n Bruta Mensualizada"

colnames(tablaleida)

# Se genera una nueva variable con la tabla a la que se elimin� la fila.
# Posteriormente, se eliminan las columnas de la variable sin fila, y se le asigna otra variable.
# esta es la tabla limpia.

tablaleida_modificada <- tablaleida[c(-1),]
View(tablaleida_modificada)

names(tablaleida_modificada)
TablaLimpia3 <-tablaleida_modificada[1:15]
names(TablaLimpia3)

View(TablaLimpia3)


# Una vez las tablas est�n limpias, se procede a respaldar los archivos en formato .csv
# Para ello se utiliz� setwd() y write.csv()

  #DATA FRAME EX CNC
setwd("C:/Users/marti/OneDrive/Desktop/Data Depa")
write.csv(TablaLimpia1, file = "MArtin_Aguilar_R_ExCnC.csv")

# DATA FRAME INDAP
setwd("C:/Users/marti/OneDrive/Desktop/Data Depa")
write.csv(TablaLimpia2, file = "Martin_Aguilar_R_INDAP.csv")

  # DATA FRAME ARAUCO
setwd("C:/Users/marti/OneDrive/Desktop/Data Depa")
write.csv(TablaLimpia3, file = "Martin_Aguilar_R_ARAUCO.csv")




####################### PASO 3 #######################
#     EXPLORACI�N Y VISUALIZACI�N DE DATA            #

# A grandes rasgos, se puede deducir que los data frames corresponden a las remuneraciones de org�nicas gubernamentales.
# Los periodos detallados corresponden a los a�os 2018 y 2019.
# Las variables mas significativas fueron asignaciones por ley, grados laborales, n�mero de empleados, cargos laborales y Regiones


# Se exploraron las tablas con el comando table()

#ALGUNAS VARIABLES GENERALES

table(TablaLimpia1$A�o) 
table(TablaLimpia1$Mes)
table(TablaLimpia1$`Calificaci�n profesional o formaci�n`)
table(TablaLimpia1$`Fecha de inicio dd/mm/aa`)
table(TablaLimpia1$`Fecha de t�rmino dd/mm/aa`)
table(TablaLimpia1$`Grado EUS / Cargo con jornada`)

table(TablaLimpia2$A�o)
table(TablaLimpia2$Mes)
table(TablaLimpia2$`Fecha de inicio dd/mm/aa`)
table(TablaLimpia2$`Fecha de t�rmino dd/mm/aa`)
table(TablaLimpia2$`Grado EUS / Cargo con jornada`)
table(TablaLimpia2$`Cargo o funci�n`)

table(TablaLimpia3$Grado)
table(TablaLimpia3$`A. de Zona`)

########## GRAFICOS Y OTRAS VARIABLES  ##########


### GR�FICOS E INFORMACI�N EXCNA  ###

table(TablaLimpia1$Estamento) # El organismo est� compuesto por 100 empleados, de los cuales; 33 administrativos, 56 profesionales y 11 t�cnicos.
ggplot(data = TablaLimpia1, aes(x=Regi�n)) + geom_bar()+ coord_flip() + ggtitle("Empleados Ex CNA por Regi�n")

table(TablaLimpia1$Regi�n) # Las regiones con mayor n� de empleados son RM y Valparaiso
ggplot(data = TablaLimpia1, aes(x=Estamento)) + geom_bar()+ coord_flip() + ggtitle("Empleados por Estamento Ex CNA")

RM <- TablaLimpia1 %>% select(Regi�n, Estamento) %>% filter(Regi�n == "Regi�n Metropolitana de Santiago")
VP <- TablaLimpia1 %>% select(Regi�n, Estamento) %>% filter(Regi�n == "Regi�n de Valpara�so")
View(RM)
View(VP)

table(RM$Regi�n)
table(RM$Estamento) # De los 100 empleados, 29 son de la RM; con tendencia laboral a Profesionales (24/29)
table(VP$Regi�n)
table(VP$Estamento)# De los 100 empleados, 37 son de Valpara�so,con una distribuci�n similar entre administrativos (17/37) y Profesionales (16/37)

ggplot(data = RM, aes(x=Estamento)) + geom_bar() + ggtitle("Estamentos Regi�n Metropolitana")
ggplot(data = VP, aes(x=Estamento)) + geom_bar() + ggtitle("Estamentos Valparaiso")


table(TablaLimpia1$`Asignaciones especiales`) # EL organismo cuenta con 3 tipos de asignaci�n; (33), (37) y (131)
ggplot(data = TablaLimpia1, aes(x=`Asignaciones especiales`)) + geom_bar() + ggtitle("N�mero de Asignaciones Ex CNA")

Asig_RM <- TablaLimpia1 %>% select(Regi�n, `Asignaciones especiales`) %>% filter(Regi�n == "Regi�n Metropolitana de Santiago")
Asig_VP <- TablaLimpia1 %>% select(Regi�n, `Asignaciones especiales`) %>% filter(Regi�n == "Regi�n de Valpara�so")
View(Asig_RM)
View(Asig_VP)

table(Asig_RM$`Asignaciones especiales`) # De los 29 empleados; 21 reciben la asignaci�n (33) y 8 reciben la asignaci�n (131)
table(Asig_VP$`Asignaciones especiales`) # De los 37 empleados;22 reciben la asignaci�n (33) y 15 reciben la asignaci�n (131)

ggplot(data = Asig_RM, aes(x=`Asignaciones especiales`)) + geom_bar() + ggtitle("N�mero de Asignaciones CNA/ RM")
ggplot(data = Asig_VP, aes(x=`Asignaciones especiales`)) + geom_bar() + ggtitle("N�mero de Asignaciones CNA/ Valpara�so")


table(TablaLimpia1$`Remuneraci�n bruta mensualizada`) # El monto de los sueldos fluctua entre los [$750.000 : $3.425.000]

table(Remu_RM$`Remuneraci�n bruta mensualizada`) # El sueldo en la RM fluctua entre los [$750.00 : $3.283.000]
table(Remu_VP$`Remuneraci�n bruta mensualizada`) # El sueldo en Valpara�so fluctua entre los [$859.00 : $3.283.000]

Remu_RM <- TablaLimpia1 %>% select(Regi�n, Estamento,`Remuneraci�n bruta mensualizada`) %>% filter(Regi�n == "Regi�n Metropolitana de Santiago")
Remu_VP <- TablaLimpia1 %>% select(Regi�n, Estamento,`Remuneraci�n bruta mensualizada`) %>% filter(Regi�n == "Regi�n de Valpara�so")




### GR�FICOS E INFORMACI�N INDAP ###

table(TablaLimpia2$Regi�n)# Las regiones con mayor n� de empleados son RM, Regi�n del Maule y Regi�n de los lagos
ggplot(data = TablaLimpia2, aes(x=Regi�n)) + geom_bar()+ coord_flip() + ggtitle("Empleados INDAP por Regi�n") 


RM2<- TablaLimpia2%>% select(Regi�n, Estamento,`Remuneraci�n bruta mensualizada`, `Asignaciones especiales`) %>% filter(Regi�n == "Regi�n Metropolitana de Santiago")
MAULE <- TablaLimpia2%>% select(Regi�n, Estamento,`Remuneraci�n bruta mensualizada`, `Asignaciones especiales`)%>% filter(Regi�n == "Regi�n del Maule")
LAGOS <- TablaLimpia2%>% select(Regi�n, Estamento,`Remuneraci�n bruta mensualizada`, `Asignaciones especiales`)%>% filter(Regi�n == "Regi�n de Los Lagos")

table(RM2$Estamento) # De los 100 empleados, 16 pertenecen a la RM, con una tendencia hacia los empleados profesionales
table(MAULE$Estamento) # De los 100 empleados, 16 pertenencen a la Regi�n del Maule con tendencia hacia los empleados profesionales
table(LAGOS$Estamento) # De los 100 empleados, 13 pertenecen a la REgi�n de los LAGOS con tendencia a empleados profesionales


table(TablaLimpia2$Estamento) #EL organismo est� compuesto por 7 administrativos, 70 profesionales y 23 t�cnicos.
ggplot(data = TablaLimpia2, aes(x=Estamento)) + geom_bar()+ coord_flip() + ggtitle("Empleados INDAP por Estamento") 

table(TablaLimpia2$`Asignaciones especiales`) #El organismo cuenta con 4 tipos de asignaciones; (01), (33), (37), (64)
ggplot(data = TablaLimpia2, aes(x=`Asignaciones especiales`)) + geom_bar() + ggtitle("N�mero de asignaciones INDAP")

table(RM2$`Asignaciones especiales`) # De los 16 empleados, 7 reciben asignaci�n tipo (01) y 9 reciben asignaci�n tipo (33)
table(MAULE$`Asignaciones especiales`) # De los 16 empleados, 4 reciben asginaci�n(01), 1 reciben asignaci�n (37), y 11 reciben (33) y (37)
table(LAGOS$`Asignaciones especiales`) # De los 13 empleados 3 reciben asignaci�n (37), 5 reciben (33) y (37), y 5 recien (33)(37)(64)

table(TablaLimpia2$`Remuneraci�n bruta mensualizada`) # El monto de los sueldos fluctua entre los [$785.000 : $3.590.000]

table(RM2$`Remuneraci�n bruta mensualizada`) # El monto de los sueldos en la RM [$838.000 : $2.980.000]
table(MAULE$`Remuneraci�n bruta mensualizada`)  # El monto de los sueldos en la Regi�n del Maule [$838.643 : 2.603.000]
table(LAGOS$`Remuneraci�n bruta mensualizada`)# El monto de los sueldos en la Regi�n de Los Lagos [$836.000 : $ 2.837.000]


table(TablaLimpia2$`Grado EUS / Cargo con jornada`)
ggplot(data = TablaLimpia2, aes(x=`Grado EUS / Cargo con jornada`)) + geom_bar() + ggtitle("Cantidad de grados INDAP") 

grado_RM<- TablaLimpia2%>% select(Regi�n, Estamento,`Grado EUS / Cargo con jornada`) %>% filter(Regi�n == "Regi�n Metropolitana de Santiago") 
grado_ML<- TablaLimpia2%>% select(Regi�n, Estamento,`Grado EUS / Cargo con jornada`)%>% filter(Regi�n == "Regi�n del Maule")
grado_LGS <- TablaLimpia2%>% select(Regi�n, Estamento,`Grado EUS / Cargo con jornada`)%>% filter(Regi�n == "Regi�n de Los Lagos")

table(grado_RM$`Grado EUS / Cargo con jornada`)
table(grado_ML$`Grado EUS / Cargo con jornada`)
table(grado_LGS$`Grado EUS / Cargo con jornada`)



### GR�FICOS E INFORMACI�N R.ARAUCO ###

table(TablaLimpia3$Estamento) # El organismo est� compuesto por 4 administrativos, 1 auxiliar, 3 directivos, 7 profesionales y 3 t�cnicos 
ggplot(data = TablaLimpia3, aes(x=Estamento)) + geom_bar()+ coord_flip() + ggtitle("Empleados Gob. Regional ARAUCO ")

table(TablaLimpia3$Grado)
ggplot(data = TablaLimpia3, aes(x=Grado)) + geom_bar() + ggtitle("Cantidad de grados Gob.Reg.ARAUCO")

table(TablaLimpia3$`Sueldo Base`) #El suendo base fluctua entre los [$194.000 : $590.500[

table(TablaLimpia3$`Total Remuneraci�n Bruta Mensualizada`) # El monto de los sueldos fluctua entre los [$737.000 : $5.089.000 ]



###################### PASO 4 ######################
#                 PREGUNTA EFECTUADA               #

# � Es mejor remunerado el trabajo gubernamental en Santiago o en otras regiones?

  # Para responder esta pregunta nos basaremos en las estad�sticas efectuadas en el "PASO 3"
# En la totalidad de los 3 organismos gubernamentales, contamos con 218 observaciones.
# De estos 218 empleados observados, existe un total de 45 empleados de la RM; 37 de la R. Valpara�so ; 28 en Arauco ; 16 en Maule y 16 en Los Lagos  
#  (Solo tomaremos las regiones con mayor numero de empleados)

# Se puede apreciar una tendencia de sueldos dada por;
table(RM2$`Remuneraci�n bruta mensualizada`) # El monto de los sueldos en la RM [$838.000 : $2.980.000]
table(Remu_RM$`Remuneraci�n bruta mensualizada`) # El sueldo en la RM fluctua entre los [$750.00 : $3.283.000]    
                                                      # Uniendo las 2 datas, la RM fluctua entre[$750.000 : 3.283.000]
table(Remu_VP$`Remuneraci�n bruta mensualizada`) # El sueldo en Valpara�so fluctua entre los [$859.00 : $3.283.000]
table(MAULE$`Remuneraci�n bruta mensualizada`)  # El monto de los sueldos en la Regi�n del Maule [$838.643 : 2.603.000]
table(LAGOS$`Remuneraci�n bruta mensualizada`)# El monto de los sueldos en la Regi�n de Los Lagos [$836.000 : $ 2.837.000]

#Con respecto a los perfiles de los empleados:
table(RM2$Estamento) # De los 100 empleados, 16 pertenecen a la RM, con una tendencia hacia los empleados profesionales (10/16)
table(MAULE$Estamento) # De los 100 empleados, 16 pertenencen a la Regi�n del Maule con tendencia hacia los empleados profesionales (11/16)
table(LAGOS$Estamento) # De los 100 empleados, 13 pertenecen a la REgi�n de los LAGOS con tendencia a empleados profesionales (9/13)
table(RM$Estamento) # De los 100 empleados, 29 son de la RM; con tendencia laboral a Profesionales (24/29)
table(VP$Estamento)# De los 100 empleados, 37 son de Valpara�so,con una distribuci�n similar entre administrativos (17/37) y Profesionales (16/37)

#Con respecto a las asignaciones
table(RM2$`Asignaciones especiales`) # De los 16 empleados, 7 reciben asignaci�n tipo (01) y 9 reciben asignaci�n tipo (33)
table(Asig_RM$`Asignaciones especiales`) # De los 29 empleados; 21 reciben la asignaci�n (33) y 8 reciben la asignaci�n (131)
                                            # Uniendo las 2 data, RM: 7 tipo (01), 30tipo (33) y 8 tipo (131)
table(MAULE$`Asignaciones especiales`) # De los 16 empleados, 4 reciben asginaci�n(01), 1 reciben asignaci�n (37), y 11 reciben (33) y (37)
table(LAGOS$`Asignaciones especiales`) # De los 13 empleados 3 reciben asignaci�n (37), 5 reciben (33) y (37), y 5 recien (33)(37)(64)
table(Asig_VP$`Asignaciones especiales`) # De los 37 empleados;22 reciben la asignaci�n (33) y 15 reciben la asignaci�n (131)


# En conclusi�n, existe un mayor pago en La Regi�n Metropolitana y La Regi�n de Valpara�so, en cuanto a sueldos menzuales brutos.
# Sin embargo, en lo referente a n�mero de asignaciones, las regiones del sur superan considerablemente el monto y la cantidad de asignaciones.
# Existe una tendencia a la existencia de empleados con t�tulos profesionales en los puestos laborales p�blicos estudiados.
