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
    if (input$player != ""){
      player.data <- player.data %>% filter(grepl(input$player, Player))
      View(player.data)
    } else{
      # Filter Year Range
      player.data <- player.data %>% filter(Year >= input$Year[1] & Year <= input$Year[2])
      # Filter Round
      player.data <- player.data %>% filter(Rnd >= input$round[1] & Rnd <= input$round[2])
      
      ### Attempt to filter by team and pos inputs ---- Only filters with team, does not work with Position ####
      if (input$Team != 'Both'){
        player.data <- player.data %>% filter(Team == input$Team)
        if (input$Pos != 'All'){
          player.data <- player.data %>% filter(Pos == input$Pos)
        }
      }   
    }
    
    # Filters colleges to be ploted to only the colleges with draft picks meeting the criteria above
    map.college.data <- college.data %>% filter(Official.Name %in% player.data$Official.Name)
    
    # Construct the labeling
    # One round versus multiple
    if (input$round[1] == input$round[2]) { # One round
      round.string <- paste0(" in round ", input$round[1])
    } else { # Multiple rounds
      round.string <- paste0(" between rounds ", input$round[1], " and ", input$round[2])
    }
    # One year versus multiple
    if (input$Year[1] == input$Year[2]) { # one year
      year.string <- paste0(" In the year ", input$Year[1], ", ")
    } else { # multiple years
      year.string <- paste0("Between the years ", input$Year[1], " and ", input$Year[2], ", ")
    }
    
    #### Josh needs to be explained what is going on here ####
    tester.data <- player.data %>% filter(Official.Name == map.college.data$Official.Name)
    tester.num <- nrow(tester.data) # wrong
    
    # Stats for the college label, how many picks during the year and what position.
    if (input$player == "" && input$Pos != "All") {
      college.stats <-  paste0(year.string, tester.num ," ", input$Pos,
                             "'s were drafted", round.string)
    } else if (input$player == "" && input$Pos == "All"){  # If position is All, change to "players"
      college.stats <- paste0(year.string, tester.num , " players's were drafted", round.string)
    } else{ # If single player is searched for
      college.stats <- paste0("In ", player.data$Year, ", ", player.data$Player, " was drafted by ", player.data$Tm, ". He was picked in round ",
                              player.data$Rnd, " (", player.data$Pick, " overall)")
    }
    # Apply line break to labels
    labs = paste0(map.college.data$Official.Name, '<br />', 
                   college.stats)
    # render map
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
      labelOptions = labelOptions(direction = 'top', style = list()),
      lng = (as.numeric(map.college.data$LONGITUDE)), lat = (as.numeric(map.college.data$LATITUDE)), icon = makeIcon(
        iconUrl = map.college.data$X.1,
        iconWidth = 50, iconHeight = 40)) %>% 
      addTiles()
    nfl.map
  })
})

