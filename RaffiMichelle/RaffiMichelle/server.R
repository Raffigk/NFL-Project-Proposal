library(shiny)
library(plotly)
library(dplyr)

#Organizing Data

full.draft.data <- read.csv('Info201/NFL-Project-Proposal/data/Final_Draft_Data.csv', stringsAsFactors = FALSE)
#Data for this chart
draft.data <- full.draft.data %>% 
  select(Year, Rnd, Pick, Player, Pos, Cmp, Pass_Att, Pass_Yds, Pass_Int, Rush_Att, Rush_Yds, Rush_TDs, Rec, Rec_Yds, Rec_Tds, Tkl, Def_Int, Sk, Official.Name, To, Age)
#Aggregates Players based on position type
defense.team <- c('DT', 'DE', 'DB', 'MLB', 'OLB', 'CB', 'S', 'FS', 'ILB', 'DL', 'SS', 'LB')
offense.team <- c('C', 'G', 'T', 'QB', 'RB', 'WR', 'TE', 'OL', 'NT', 'FB')
special.team <- c('K', 'H', 'LS', 'P', 'KOS', 'KR', 'PR')
#Function to add position type column to data
GetTeam <- function(pos) {
  if (length(grep(pos, defense.team)) != 0) {
    team = 'Defense'
  } else if (length(grep(pos, offense.team)) != 0) {
    team = 'Offense'
  } else if (length(grep(pos, special.team)) != 0) {
    team = 'Special Teams'
  } else {
    team = NULL
  }
  return (team)
}
#Adding column to make calculations easier
Agg_Position <- function(pos) {
  if (pos == 'LB' | pos == 'MLB' | pos == 'ILB' | pos == 'OLB') {
    new.pos = 'LB'
  } else if (pos == 'S' | pos == 'SS' | pos == 'FS') {
    new.pos = 'S'
  } else if (pos == 'CB' | pos == 'DB') {
    new.pos = 'CB'
  } else {
    new.pos = pos
  }
  return(new.pos)
}
# Add column to dataframe that includes specific positions
draft.data <- draft.data %>% 
  mutate(Team= (lapply(draft.data$Pos, GetTeam)))
# Because some positions are very specific, add a column to the dataframe that provides a generalized position for each player
draft.data <- draft.data %>%
  mutate(GenPos = (lapply(draft.data$Pos, Agg_Position)))
#Adds 2016 as year to for players who have only played one year
draft.data <- draft.data %>%
  mutate(To = ifelse(is.na(To),2016,To))


  shinyServer(function(input, output) {
    output$statPlot <- renderPlotly({

      StatAverageByYear <- function(year) {
        cumulative.stat.data <- draft.data %>% filter(GenPos == input$GenPos & Year == year)
        seasons.played <- mean(cumulative.stat.data$To - cumulative.stat.data$Year)        
        stat.data <- cumulative.stat.data %>% select_(input$Stat)
        plot.data <-  stat.data %>% filter(!is.na(input$Stat))
        stat.ave <- mean(plot.data[[1]])
        stat.ave <- round(stat.ave, digits = 2)
        ave.stat <- stat.ave / seasons.played
        data.plot <- data.frame(Year = year, Stat = ave.stat)
        return(data.plot)
      }
      year <- unique(draft.data$Year)
      plot.data <- lapply(year, StatAverageByYear) %>% bind_rows()
      plot.data <- unique(plot.data)
      
      y <- list(
        title = input$Stat
      )
      
      plot_ly(plot.data, x = ~Year, y = ~Stat, name = "Statistics Plot", type='scatter') %>% 
        add_trace(mode = "markers") %>% 
        layout(yaxis = y)
    })
  })
  
