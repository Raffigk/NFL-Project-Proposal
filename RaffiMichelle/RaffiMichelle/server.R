library(shiny)
shinyServer(function(input, output) {
  
  #Aggregating similar positions
  LB <- c('LB', 'MLB', 'ILB', 'OLB') #make all values equal to LB for calculations
  S <- c('S', 'FS', 'SS') #make all values equal to S for calculations
  CB <- c('CB', 'DB') #make all values equal to CB for calculations
  
  
  # scatterplot: x axis = set of years from 1985-2015 (30 pts for each statistic)
  # user selects position and statistic
  # each datapoint represents one year
  # calculate average of statistic per year
  # y axis = statistic 
  
  unique.years <- unique(draft.data$Year)
  
  GetYearAvg <- function(pos.type, pos, stat, year) {
    year.data <- draft.data %>%
      filter(Team == pos.type, GenPos == pos, stat >= 0) %>%
      group_by(Year) %>%
      arrange(Year) %>% 
      filter(Year == year) %>%
      summarise(mean = mean(Def_Int))
    return (year.data$mean)
    
  }
  
  
})
