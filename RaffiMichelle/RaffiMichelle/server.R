library(shiny)
library(plotly)
library(dplyr)

  shinyServer(function(input, output) {
    
    output$selectedStats <- renderUI({
        if(input$GenPos == 'QB') {
          selectInput(inputId = 'Stat', 'Statistic:', choices = c('Pass Completions' = 'Cmp', 'Pass Attempts' = 'Pass_Att', 'Passing Yards' = 'Pass_Yds', 'Pass Interceptions' = 'Pass_Int', 'Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds'), selected = 'Passing Yards')
        } else if (input$GenPos == 'TE') {
          selectInput(inputId = 'Stat', 'Statistic:', choices = c('Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'), selected = 'Receiving Yards')
        } else if (input$GenPos == 'RB' | input$GenPos == 'WR' | input$GenPos == 'FB') {
          selectInput(inputId = 'Stat', 'Statistic:', choices = c('Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'), selected = 'Rushing Yards')
        } 
      #else if (input$GenPos == 'S' | input$GenPos == 'CB' | input$GenPos == 'De' | input$GenPos == 'LB' | input$GenPos == 'NT') {
        #   selectInput(inputId = 'Stat', 'Statistic:', choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'), selected = 'Tackles')
        # }
    })
    
    output$statPlot <- renderPlotly({

      StatAverageByYear <- function(year) {
        print(input$Stat)
        print(input$GenPos)
        cumulative.stat.data <- draft.data %>% filter(GenPos == input$GenPos & Year == year)
        seasons.played <- mean(cumulative.stat.data$To - cumulative.stat.data$Year)        
        stat.data <- cumulative.stat.data %>% select_(input$Stat)
        plot.data <-  stat.data %>% filter(!is.na(stat.data))
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
  
