library(shiny)
library(dplyr)
library(leaflet)
library(stringr)

# Define server logic for slider examples
shinyServer(function(input, output) {
  # Show the values using an HTML table
  output$map <- renderLeaflet({
    # data for all players
    player.data <- draft.data 
    
    # data for each individual college
    college.data <- read.csv("Data/map.college.data.csv", stringsAsFactors = FALSE) 
    # Filter Year Range
    player.data <- player.data %>% filter(Year >= input$Year[1] & Year <= input$Year[2])
    # Filter Round
    player.data <- player.data %>% filter(player.data$Rnd >= input$round[1] & player.data$Rnd <= input$round[2])
    
     if (input$Team != 'Both'){
      player.data <- player.data %>% filter(Team == input$Team)
     # player.data <- player.data %>% filter(Pos == input$Pos)
     }
    #player.data <- player.data %>% filter(Pos == "RB")
    map.college.data <- college.data %>% filter(Official.Name %in% player.data$Official.Name)
    
    tester.data <- player.data %>% filter(Official.Name == map.college.data$Official.Name)
    tester.num <- nrow(tester.data)
    
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
        
        label = paste(strwrap(map.college.data$Official.Name),  paste0(tester.num ," ", strwrap(input$Pos), "'s drafted"), sep = ": ") ,
        
        lng = (as.numeric(map.college.data$LONGITUDE)), lat = (as.numeric(map.college.data$LATITUDE)), icon = makeIcon(
          iconUrl = map.college.data$X.1,
          iconWidth = 50, iconHeight = 40)) %>% 
      addTiles()
    
    nfl.map
})
  })
