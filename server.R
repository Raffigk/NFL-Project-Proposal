library(shiny)
library(dplyr)
library(leaflet)
library(stringr)

# Define server logic for slider examples
shinyServer(function(input, output) {
  # Show the values using an HTML table
  output$map <- renderLeaflet({
    player.data <- read.csv("Data/map.player.data.csv", stringsAsFactors = FALSE)
    college.data <- read.csv("Data/map.college.data.csv", stringsAsFactors = FALSE)
    # Filter Year Range
    #map.player.data <- player.data %>% Year >= input$Year[1] & Year <= input$Year[2]
    # Filter Round
    #map.player.data <- map.player.data[map.player.data$Rnd == input$round,]
    if (input$Pos != 'All'){
      player.data <- player.data %>% filter(Pos == input$Pos)
    }
    map.college.data <- college.data %>% filter(Official.Name %in% player.data$Official.Name)
    
    nfl.map<- map.college.data %>%
      leaflet() %>%
      addTiles() %>%
      setView(lng = -114.805089, lat = 35.3327636, zoom = 3) %>%
      addMarkers(clusterOptions = markerClusterOptions(iconCreateFunction=JS(
        iconCreateFunction=JS("function (cluster) {    
                              var childCount = cluster.getChildCount(); 
                              var c = ' marker-cluster-';  
                              c += 'small';  
                              return new L.DivIcon({ html: 
                              '<div><span>' + childCount + '</span></div>', 
                              className: 'marker-cluster' + c, iconSize: new 
                              L.Point(40, 40)});}"))),
        
        label = paste(strwrap(map.college.data$Official.Name),  paste0(strwrap(map.college.data$n), " NFL players drafted"), sep = ": ") ,
        
        lng = (as.numeric(map.college.data$LONGITUDE)), lat = (as.numeric(map.college.data$LATITUDE)), icon = makeIcon(
          iconUrl = map.college.data$X.1,
          iconWidth = 50, iconHeight = 40)) %>% 
      addTiles()
    
    nfl.map
  })
})
