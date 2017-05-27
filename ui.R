# INFO 201 Group Final Project
# Michelle Ho, Raffi Gharakhanian, Jon Cantle, Josh Dugger
library(shiny)
library(leaflet)

shinyUI(fluidPage(    
  
  titlePanel(h1("Where Do Draft Picks Come From?", align = 'center')),
  
  sidebarLayout(      
    
    sidebarPanel(
      #Slider for year selector
      sliderInput(inputId = "Year", "Choose the Year(s)",
                  min = 2000, max = 2015, value = c(2000, 2015), sep = ""),
      #Slider for round selector
      sliderInput(inputId = "round", "Choose the Round(s)",
                  min = 1, max = 12,  value = c(1, 12), sep = ""),
      #Select Team Type
      selectInput(inputId = "Team", "Position Type:", 
                  choices = c('Offense' = 'Offense', 'Defense' = 'Defense'),#, 'Both' = 'Both'),
                  selected = 'Offense'),
      #If the team type is both, select all positions
      # conditionalPanel(
      #   condition = "input.Team == 'Both'",
      #   selectInput(inputId = 'Pos', "Position:",
      #               choices = c('All' = 'All'),
      #               selected = 'All')
      # ),
      #If the Position Type is Offense, select offensive positions
      conditionalPanel(
        condition = "input.Team == 'Offense'", 
        selectInput(inputId = 'Pos', 'Position:', 
                    choices = c('Quarterback' = 'QB', 'Running Back' = 'RB', 'Tight End' = 'TE', 'Wide Receiver' = 'WR', 'Fullback' = 'FB'), 
                    selected = 'Quarterback')
      ),
      #If the Position Type is Defense, select defensive positions      
      conditionalPanel(
        condition = "input.Team == 'Defense'",
        selectInput(inputId = 'P', 'Position:', 
                    choices = c('Safety' = 'S', 'Cornerback' = 'CB', 'Defensive End' = 'DE', 'Linebacker' = 'LB', 'Defensive Tackle' = 'NT'), 
                    selected = 'Cornerback')
      )
    ),
    mainPanel(
      leafletOutput("map")
    )
  )
))

#conditionalPanel(
# condition = "input.Pos == 'S'", #| input.Pos == 'CB' | input.Pos == 'DE' | input.Pos == 'LB' | input.Pos == 'NT'",
# selectInput(inputId = 'Statistic', 'Statistic:', choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'), selected = 'Tackles')
#),