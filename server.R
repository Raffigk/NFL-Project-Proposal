library(shiny)
library(dplyr)
library(leaflet)
library(stringr)

# Define server logic for slider examples
shinyServer(function(input, output) {
  # Show the values using an HTML table
  output$map <- renderLeaflet({
    # data for all players
    player.data <- draft.data  #From OrganizeData, need to write a csv for this.
    
    # data for each individual college
    college.data <- read.csv("Data/map.college.data.csv", stringsAsFactors = FALSE) 
    # Filter Year Range
    player.data <- player.data %>% filter(Year >= input$Year[1] & Year <= input$Year[2])
    # Filter Round
    player.data <- player.data %>% filter(player.data$Rnd >= input$round[1] & player.data$Rnd <= input$round[2])
    
    #filters out the player that the user enters.
    if (input$player != "") {
      player.data <- player.data %>% filter(player.data$Player == input$player)
    }# error 2 cases: peyton manning(idk why not working), ike taylor(guy with no university)
    
    
     if (input$Team != 'Both'){
      player.data <- player.data %>% filter(Team == input$Team)
     # player.data <- player.data %>% filter(Pos == input$Pos)
     }
    
    #player.data <- player.data %>% filter(Pos == "RB")
    map.college.data <- college.data %>% filter(Official.Name %in% player.data$Official.Name)
    
    
    
    
    if (input$round[1] == input$round[2]) {
      round.string <- paste0(" in round ", input$round[1])
    } else {
      round.string <- paste0(" between rounds ", input$round[1], " and ", input$round[2])
    }
    
    if (input$Year[1] == input$Year[2]) {
      year.string <- paste0(" In the year ", input$Year[1], ", ")
    } else {
      year.string <- paste0("Between the years ", input$Year[1], " and ", input$Year[2], ", ")
    }
    
    tester.data <- player.data %>% filter(Official.Name == map.college.data$Official.Name)
    tester.num <- nrow(tester.data) # wrong
    
    if (input$player == "") {
    college.stats <-  paste0(year.string, tester.num ," ", input$Pos,
                             "'s drafted", round.string)
    } else {
      college.stats <- paste0("In ", player.data$Year, ", ", input$player, " was drafted by ", player.data$Tm, ". He was picked in round ",
                              player.data$Rnd, " (", player.data$Pick, " overall)")
    }
    
    labs = paste0(map.college.data$Official.Name, '<br />', 
                   college.stats)
    
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
        
        label = lapply(labs, HTML),
        
       #label = paste0(strwrap(map.college.data$Official.Name),": ", college.stats),
       #label = htmltools::HTML(paste0(map.college.data$Official.Name,":<br/>", college.stats)), 
       #This is my attempt to make multiple lines^, grrr why doesnt it work, doesnt look at map.coll.ege.data$Official.Name like the map normally does.
        labelOptions = labelOptions(direction = 'top', style = list()),
        
        
        lng = (as.numeric(map.college.data$LONGITUDE)), lat = (as.numeric(map.college.data$LATITUDE)), icon = makeIcon(
          iconUrl = map.college.data$X.1,
          iconWidth = 50, iconHeight = 40)) %>% 
      addTiles()
    
    nfl.map
})
  })

