library(rnaturalearth)
library(sp)
library(wbstats)
library(DT)
library(leaflet)
library(dplyr)

map <- ne_countries()
plot(map)

indicadores <- wb_search(pattern="pollution")

indicator <- wb_data(indicator = "EN.ATM.PM25.MC.M3",start_date=2016, end_date=2016)

names(indicator)[5] <-'value'

map$PM2.5 <-indicator[match(map$iso_a3,indicator$iso3c),"value"] %>% pull(value)

DT::datatable(map@data[c("iso_a3","name","PM2.5")],
              rownames=FALSE,
              options=list(pageLength=10))

pal <- colorBin(palette = "viridis", 
                domain = map$PM2.5, 
                bins = seq(0,max(map$PM2.5,na.rm = TRUE),by=10)
)

map$labels <- paste0("<strong> Pais: </strong>",
                     map$name, "<br/>",
                     "<strong> PM2.5: </strong>",
                     round(map$PM2.5),"<br/>")%>%lapply(htmltools::HTML)

leaflet(map)%>%
  addTiles()%>%
  setView(lng=0,lat=30,zoom =2)%>%
  addPolygons(fillColor = ~pal(PM2.5),
              color = "white",
              fillOpacity = 0.7,
              label = ~labels,
              highlight =highlightOptions(color = "black",bringToFront = TRUE)
  )%>%
  addLegend(pal=pal,
            values = ~PM2.5,
            opacity = 0.7,
            title = "PM2.5") 

