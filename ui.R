library(shiny)
library(leaflet)
library(rgdal)

shinyUI(fluidPage(
  h1("Casos de COVID-19 en la Región de Murcia y en sus municipios",align="center"),
  br(),
  p(c("En esta aplicación web, creada con Shiny y R, se muestran los casos de COVID 19"),
    strong("DETECTADOS"),"en los municipios de la Región de Murcia.",
    strong("IMPORTANTE:"),
    "Los municipios marcados en azul en el mapa son aquellos que presentan",
    strong("menos de cinco casos detectados."),"Por tanto, un municipio señalado en azul",strong( "puede o no"), "tener casos registrados de COVID-19."),
  p("Asimismo, tanto los datos mostrados en el mapa, como en la tabla del apartado", strong(em("Otros datos de interés,")) ,"pertenecen",strong("a los casos de los que se dispone de información detallada."),c("Estos casos no siempre tienen que coincidir con el número total de infectados detectados hasta la fecha")),
  sidebarLayout(
    sidebarPanel(selectInput("fecha",label="Escoger día",choices=c("25/03","27/03","30/03","01/04","03/04","06/04","08/04","10/04","13/04","15/04","17/04","20/04"))),
    mainPanel(
      tabsetPanel(
        tabPanel("Mapa de casos detectados", 
                 br(),
                 leafletOutput(outputId="mapa")),
        tabPanel("Otros datos de interés",
                 br(),
                 tableOutput(output="tabla")),
        tabPanel("Informes de situación", 
                 br(),
                 p("Los datos aquí mostrados han sido obtenidos de los diferentes informes remitidos por la Consejería de Salud de la Comunidad Autónoma:"),
                 br(),
                 a(href="http://mula.es/web/wp-content/uploads/2020/03/458867-INFORME_COVID-19_MURCIA.pdf","Informe de situación a 25/03/2020"),
                 br(),
                 a(href="http://abarandiaadia.com/upload/files/03_2020/4119_458891-covidinformeepidemiologico20200327_compressed.pdf","Informe de situación a 27/03/2020"),
                 br(),
                 a(href="https://sietediasalhama.com/adjuntos/5400/INFORME_COVID-19_REGION_DE_MURCIA_20200330.pdf","Informe de situación a 30/03/2020"),
                 br(),
                 a(href="http://www.puertolumbreras.es/ayuntamiento/wp-content/uploads/2020/04/459151-INFORME.COVID-19.REGION.DE_.MURCIA.202004014.pdf","Informe de situación a 01/04/2020"),
                 br(),
                 a(href="http://mula.es/web/wp-content/uploads/2020/04/459151-INFORME-COVID-19_REGION-DE-MURCIA-20200403.pdf","Informe de situación a 03/04/2020"),
                 br(),
                 a(href="http://www.murciasalud.es/recursos/ficheros/459151-INFORME-COVID-19-REGION-DE-MURCIA-20200406.pdf","Informe de situación a 06/04/2020"),
                 br(),
                 a(href="http://www.murciasalud.es/recursos/ficheros/459151-INFORMECOVID-19REGIONDEMURCIA20200408.pdf","Informe de situación a 08/04/2020"),
                 br(),
                 a(href="http://www.murciasalud.es/recursos/ficheros/459151-INFORME_COVID_10_04.pdf","Informe de situación a 10/04/2020"),
                 br(),
                 a(href="http://www.murciasalud.es/recursos/ficheros/459151-INFORME.COVID-19.REGION.DE_MURCIA.20200413.pdf","Informe de situación a 13/04/2020"),
                 br(),
                 a(href="http://www.murciasalud.es/recursos/ficheros/459151-INFORME.COVID-19.REGION.DE.MURCIA.20200415.pdf","Informe de situación a 15/04/2020"),
                 br(),
                 a(href="http://www.murciasalud.es/recursos/ficheros/459151-INFORME-COVID-19.REGION.20200417.pdf","Informe de situación a 17/04/2020"),
                 br(),
                 a(href="http://www.murciasalud.es/recursos/ficheros/459151-INFORME-COVID-19-REGION-DE-MURCIA-20200420.pdf","Informe de situación a 20/04/2020"))
      )
    
    )
  
)))


  
