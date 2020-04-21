library(rgdal)
library(leaflet)
library(htmlwidgets)
library(dplyr)


shinyServer(function(input,output){
  output$mapa<-renderLeaflet({
    municipios<-readOGR(dsn="municipios.shp",
                        layer="municipios",
                        encoding="ESRI Shapefile")
    municipios<-spTransform(municipios,CRS("+init=epsg:4326"))
    
    n_casos<-readOGR(dsn="casos_municipios.shp",
                     layer="casos_municipios",
                     encoding="ESRI Shapefile")
    n_casos<-spTransform(n_casos,CRS("+init=epsg:4326"))
    
    equivalencia<-read.csv("equivalencias.csv",header=T,sep=";",colClasses = rep("character",2))
       
    a<-equivalencia[equivalencia$fecha_input==input$fecha,2]
    
    n_casos@data<-select(n_casos@data,ID:POBLACION,contains(as.character(a)))
    names(n_casos@data)[4]<-"num_casos"
    
    minimo<-min(n_casos@data$num_casos[n_casos@data$num_casos>0])
    radio<-(sqrt(n_casos@data$num_casos)/minimo)*3
    radio[radio==0]<-NA
    
    color<-radio
    color[is.na(color)]<-"blue"
    color[color!="blue"]<-"red"
    
    read.csv("datos.csv",header=T,sep=";",colClasses = c("character","integer","integer","integer"))%>%
      filter(Fecha==a)->temp
    
    nfecha<-c("25/03","27/03","30/03","01/04","03/04","06/04","08/04","10/04","13/04","15/04")
    
    if(input$fecha%in%nfecha){
      n_casos.popup<-paste("<h3 style='text-align:center;'>Información</h3>",
                         "<b>Municipio:</b>",n_casos@data$MUNICIPIO,"<br/>","<br/>",
                      "<table class='table'><tr>
                          <td>Nº de casos detectados</td>
                          <td>",n_casos@data$num_casos,"</td>
                         </tr>
                         <tr>
                          <td>Proporción respecto al total de infectados detectados (%)</td>
                          <td>",round(n_casos@data$num_casos*100/temp$Total2,2),"</td>
                         </tr>
                         <tr>
                          <td>Proporción de población del municipio infectada detectada (%) </td>
                          <td>",round(n_casos@data$num_casos*100/n_casos@data$POBLACION,2),"</td>
                        </tr>
                      </table>")}
    else{
      read.csv("recuperados.csv",header=T,sep=";",stringsAsFactors = F)%>%
        select(a)->recup
      names(recup)[1]<-"num_recup"
      n_casos.popup<-paste("<h4 style='text-align:center;'>Información</h4>","<br/>",
                                                    "<b>Municipio:</b>",n_casos@data$MUNICIPIO,"<br/>","<br/>",
                                                    "<table class='table'><tr>
                                                    <td>Nº de casos detectados</td>
                                                    <td>",n_casos@data$num_casos,"</td>
                                                    </tr>
                                                    <tr>
                                                    <td>Proporción respecto al total de infectados detectados (%)</td>
                                                    <td>",round(n_casos@data$num_casos*100/temp$Total2,2),"</td>
                                                    </tr>
                                                    <tr>
                                                    <td>Proporción de población del municipio infectada detectada (%) </td>
                                                    <td>",round(n_casos@data$num_casos*100/n_casos@data$POBLACION,2),"</td>
                                                    </tr>
                                                    <tr>
                                                    <td>Nº de altas epidemiológicas</td>
                                                    <td>",recup$num_recup,"</td>
                                                    </tr>
                                                    <tr>
                                                    <td>Proporción de altas respecto al número de infectados detectados (%)</td>
                                                    <td>",round(recup$num_recup*100/n_casos@data$num_casos,2),"</td>
                                                    </tr>
                                                    </table>")}
    rm(nfecha)
    
    
    leaflet()%>%
      addPolygons(data=municipios,fillColor = "green",
                  color = "black",opacity = 0.7, group="Municipios")%>%
      addCircleMarkers(data=n_casos, popup= n_casos.popup,
                       radius=radio, color=color,opacity = 1,fillOpacity = 1)%>%
      addTiles(group="Open Street Map")%>%
      addLayersControl(overlayGroups = c("Municipios"),
                       options = layersControlOptions(collapsed = TRUE)) %>%
      addLegend("bottomleft", colors = c("blue","red")
                ,labels=c("Menos de 5 casos","Más de 5 casos"), title = "Leyenda")})
  
  
  output$tabla<-renderTable({
    equivalencia<-read.csv("equivalencias.csv",header=T,sep=";",colClasses = rep("character",2))
    
    a<-equivalencia[equivalencia$fecha_input==input$fecha,2]
    b<-equivalencia[which(equivalencia$fecha_input==input$fecha)-1,2]
    
    read.csv("datos.csv",header=T,sep=";",colClasses = c("character","integer","integer","integer"))->temp
    
    if(input$fecha!="25/03"){
    
    filter(temp,Fecha==a)%>%
      select(-Fecha)->temp1
    n<-as.numeric(temp1[1,])

    filter(temp,Fecha==b)%>%
      select(-Fecha)->temp2
    m<-as.numeric(temp2[1,])
    
    p<-round((n-m)*100/m,2)
    p[c(2,3,4,7)]<-""
  
    temp1<-as.data.frame(t(temp1))
    temp1$variacion<-p

    rm(a,b,temp)
    names(temp1)<-c("Total","Variación (%)")
    rownames(temp1)<-c("Infectados detectados en la Región hasta la fecha","Infectados detectados en la Región con información detallada hasta la fecha","Infectados detectados en municipios con menos de cinco casos hasta la fecha","Infectados de la Región en otras Comunidades Autónomas hasta la fecha",
                      "Fallecidos hasta la fecha","Recuperados (alta epidemiológica) hasta la fecha","Personas infectadas confirmadas hasta la fecha (descontando recuperados y fallecidos)")
    temp1
    }
    else{
      filter(temp,Fecha==a)%>%
        select(-Fecha)->temp1
      
      temp1<-as.data.frame(t(temp1))
      
      names(temp1)<-c("Total")
      rownames(temp1)<-c("Infectados detectados en la Región hasta la fecha","Infectados detectados en la Región con información detallada hasta la fecha","Infectados detectados en municipios con menos de cinco casos hasta la fecha","Infectados de la Región en otras Comunidades Autónomas hasta la fecha",
                         "Fallecidos hasta la fecha","Recuperados (alta epidemiológica) hasta la fecha","Personas infectadas confirmadas hasta la fecha (descontando recuperados y fallecidos)")
      temp1
    }
    
  },rownames = T,striped = T,align = "c")
  })




