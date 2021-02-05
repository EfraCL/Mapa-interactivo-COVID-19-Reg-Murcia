library(ggplot2)
library(readr)

## Gantt para un año

Libro1 <- read_delim("C:/Users/User/Desktop/Libro1.csv", 
                     ";", escape_double = FALSE, col_types = cols(Fecha_inicio = col_date(format = "%d/%m/%Y"), 
                                                                  Fecha_fin = col_date(format = "%d/%m/%Y")), 
                     trim_ws = TRUE)
hitos <- read_delim("C:/Users/User/Desktop/hitos.csv", 
                    ";", escape_double = FALSE, col_types = cols(Fecha_hito = col_date(format = "%d/%m/%Y")), 
                    trim_ws = TRUE)

save.image("diagrama_grann.RData")
load("~/diagrama_grann.RData")

breaks<-c(seq.Date(as.Date("01/01/2021",format="%d/%m/%Y"),as.Date("31/12/2021",format="%d/%m/%Y"),by="month"),
          as.Date("01/01/2022",format="%d/%m/%Y"))
breaks<-breaks[c(1,4,7,10,13)]
etiquetas<-c(paste(c("Jan","Feb","Mar","Ap","May","Jun","Jul","Au","Sep","Oct","Nov","Dec"),"-21",sep = ""),"Jan-22")
etiquetas<-etiquetas[c(1,4,7,10,13)]


ggplot(Libro1,aes(x=Fecha_inicio,xend=Fecha_fin,y=Actividad,yend=Actividad))+
  geom_segment(size=4,col="green")+
  geom_point(data=hitos,aes(y=Actividad,x=Fecha_hito),inherit.aes = F,shape=18,size=2.5)+
  scale_y_discrete(limits = rev)+
  scale_x_date(breaks=breaks,labels = etiquetas,limits = c(as.Date("01/01/2021",format="%d/%m/%Y"),
                                                           as.Date("31/12/2021",format="%d/%m/%Y")))+
  geom_vline(xintercept = breaks,alpha = 0.4)+
  labs(y="",x="")+
  facet_wrap(.~Objetivo,ncol=1,scales="free_y")+
  theme_bw()+
  theme(
    axis.text.x = element_text(face="bold",size="10"),
    axis.text.y = element_text(face="bold",size="10"),
    panel.spacing = unit(0, units = "cm")
  )

# Gantt 21-24

breaks<-c(seq.Date(as.Date("01/01/2021",format="%d/%m/%Y"),as.Date("31/12/2024",format="%d/%m/%Y"),
                   by="month"),
          as.Date("01/01/2025",format="%d/%m/%Y"))
breaks<-breaks[seq(1,49,3)]

etiquetas<-c(paste(c("Jan","Feb","Mar","Ap","May","Jun","Jul","Au","Sep","Oct","Nov","Dec"),
                   rep(c("-21","-22","-23","-24"),each=12),sep = "",recycle0 =T),"Jan-25")
etiquetas<-etiquetas[seq(1,49,3)]


ggplot(Libro1,aes(x=Fecha_inicio,xend=Fecha_fin,y=Actividad,yend=Actividad))+
  geom_segment(size=4,col="green")+
  geom_point(data=hitos,aes(y=Actividad,x=Fecha_hito),inherit.aes = F,shape=18,size=2.5)+
  scale_y_discrete(limits = rev)+
  scale_x_date(breaks=breaks,labels = etiquetas,limits = c(as.Date("01/01/2021",format="%d/%m/%Y"),
                                                           as.Date("01/01/2025",format="%d/%m/%Y")))+
  geom_vline(xintercept = breaks,alpha = 0.4)+
  labs(y="",x="")+
  facet_wrap(.~Objetivo,ncol=1,scales="free_y")+
  theme_bw()+
  theme(
    axis.text.x = element_text(face="bold",size="10"),
    axis.text.y = element_text(face="bold",size="10"),
    panel.spacing = unit(0, units = "cm")
  )
