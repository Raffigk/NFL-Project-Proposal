library(shiny)

  shinyServer(function(input, output) {
    output$statPlot <- renderPlotly({
      
      cumulative.stat.data <- draft.data %>% filter(draft.data$GenPos == input$GenPos)
      
      StatAverageByYear <- function(year) {
        plot.data <- cumulative.stat.data %>% filter(Year == year & !is.na(input$Statistic)) %>% select_(input$Statistic)
        stat.ave <- mean(as.numeric(plot.data[1,]))
        stat.ave <- round(stat.ave, digits = 2)
        data.plot <- data.frame(Year = year, Stat = stat.ave)
        return(data.plot)
      }
      
      plot.data <- lapply(cumulative.stat.data$Year, StatAverageByYear) %>% bind_rows()
      plot.data <- unique(plot.data)
      
      plot_ly(plot.data, x = ~Year, y = ~Stat, name = "Statistics Plot", type='scatter') %>% 
        add_trace(mode = "markers")
    })
  })
  
  # scatterplot: x axis = set of years from 1985-2015 (30 pts for each statistic)
  # user selects position and statistic
  # each datapoint represents one year
  # calculate average of statistic per year
  # y axis = statistic 
  
  #unique.years <- unique(draft.data$Year)
  
  #GetYearAvg <- function(pos.type, pos, stat, year) {
   # year.data <- draft.data %>%
    #  filter(Team == pos.type, GenPos == pos, stat >= 0) %>%
     # group_by(Year) %>%
      #arrange(Year) %>% 
      #filter(Year == year) %>%
      #summarise(mean = mean(Def_Int))
    #return (year.data$mean)
    
  #}
  
  
#})
