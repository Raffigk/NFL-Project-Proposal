library(shiny) 
library(dplyr)
library(leaflet)
library(stringr)

source('./scripts/OrganizeDraftData.R')

# Define server logic for slider examples
shinyServer(function(input, output) {
  # Show the values using an HTML table
  output$map <- renderLeaflet({
    # data for all players
    player.data <- draft.data  #From OrganizeData, need to write a csv for this.
    
    # data for each individual college
    college.data <- read.csv("data/map.college.data.csv", stringsAsFactors = FALSE)
    if (input$player != ""){
      player.data <- player.data %>% filter(grepl(input$player, Player))
    } else{
      # Filter Year Range
      player.data <- player.data %>% filter(Year >= input$Year[1] & Year <= input$Year[2])
      # Filter Round
      player.data <- player.data %>% filter(Rnd >= input$round[1] & Rnd <= input$round[2])
      
      #Filter the player type needed.
      if (input$GenPos != 'All') {
        player.data <- filter(player.data, GenPos == input$GenPos)
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
    
    #Count of number of players that are drafted
    number.per.uni <- player.data %>% count(Official.Name)
    #combined together
    map.college.data <- left_join(map.college.data, number.per.uni, by = "Official.Name")
    
    # Stats for the college label, how many picks during the year and what position.
    if (input$player == "" && input$GenPos != "All") {
      college.stats <-  paste0(year.string,"<br />", map.college.data$n.y ," ", input$GenPos,
                               "'s were drafted", round.string)
    } else if (input$player == "" && input$GenPos == "All"){  # If position is All, change to "players"
      college.stats <- paste0(year.string, "<br />", map.college.data$n.y, " players were drafted", round.string)
    } else{ # If single player is searched for
      college.stats <- paste0("In ", player.data$Year, ", ", player.data$Player, " was drafted by ", player.data$Tm, ".<br /> He was picked in round ",
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
  
  #Changes statistics based on position chosen in UI
  output$selectedStats <- renderUI({
    if(input$GenPos2 == 'QB') {
      selectInput(inputId = 'Stat', 'Statistic:', choices = c('Pass Completions' = 'Cmp', 'Pass Attempts' = 'Pass_Att', 'Passing Yards' = 'Pass_Yds', 'Pass Interceptions' = 'Pass_Int', 'Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds'), selected = 'Passing Yards')
    } else if (input$GenPos2 == 'TE') {
      selectInput(inputId = 'Stat', 'Statistic:', choices = c('Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'), selected = 'Receiving Yards')
    } else if (input$GenPos2 == 'RB' | input$GenPos2 == 'WR' | input$GenPos2 == 'FB') {
      selectInput(inputId = 'Stat', 'Statistic:', choices = c('Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'), selected = 'Rushing Yards')
    } else if (input$GenPos2 == 'S' | input$GenPos2 == 'CB' | input$GenPos2 == 'DE' | input$GenPos2 == 'LB' | input$GenPos2 == 'NT') {
       selectInput(inputId = 'Stat', 'Statistic:', choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'), selected = 'Tackles')
    }
  })
  
  #Renders scatter plot based on position and statistic chosen
  output$statPlot <- renderPlotly({
    
    #Selects column of statistic and position the user chose and creates a dataframe by year
    StatAverageByYear <- function(year) {
      cumulative.stat.data <- draft.data %>% filter(GenPos2 == input$GenPos2 & Year == year)
      seasons.played <- mean(cumulative.stat.data$To - cumulative.stat.data$Year)        
      stat.data <- cumulative.stat.data %>% select_(input$Stat)
      plot.data <-  stat.data %>% filter(!is.na(stat.data))
      stat.ave <- mean(plot.data[[1]])
      stat.ave <- round(stat.ave, digits = 2)
      ave.stat <- stat.ave / seasons.played
      data.plot <- data.frame(Year = year, Stat = ave.stat)
      return(data.plot)
    }
    
    year <- unique(draft.data$Year) #List of years from 1985-2015
    plot.data <- lapply(year, StatAverageByYear) %>% bind_rows() #applies StatAverageByYear to include all years
    plot.data <- unique(plot.data)
    
    #Changes title of Y-Axis
    y <- list(
      title = paste0(input$Stat,' / Season')
    )
    
    plot_ly(plot.data, x = ~Year, y = ~Stat,
            name = "Statistics Plot", 
            type='scatter',
            text = ~paste0('Average ', y, ' For Year: ', round(Stat, digits = 2), '<br>Year: ', Year)) %>% 
      layout(yaxis = y)
  })
  })