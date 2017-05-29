library(shiny)
library(plotly)
library(dplyr)

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
      
      plot_ly(plot.data, x = ~Year, y = ~Stat, name = "Statistics Plot", type='scatter') %>% 
        add_trace(mode = "markers")
    })
  })
  
