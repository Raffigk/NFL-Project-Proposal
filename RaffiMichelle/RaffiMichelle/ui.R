library(shiny)

shinyUI(fluidPage(    
  
  titlePanel("Player Statistics Scatter Plot"),
  
  sidebarLayout(      
    
    sidebarPanel(
      selectInput(inputId = "Team", "Position Type:", 
                  choices = c('Offense' = 'Offense', 'Defense' = 'Defense', 'Special Teams' = 'Special Teams')),
      #Panel for Offense
      conditionalPanel(
        condition = 'input.Offense == true', 
        selectInput(inputId = 'Pos', 'Offensive Line' = c('OL', 'C', 'G', 'NT', 'T'), 'Linebacker' = c('LB', 'MLB', 'ILB', 'OLB'), 'Quarterback' = 'QB', 'Running Back' = 'RB', 'Tight End' = 'TE', 'Wide Receiver' = 'WR'), 
        selectInput(inputId = 'Statistic', '') #add statistics for Offense
        )
      #Create Conditional Panel for Defense and Special Teams
      ),
      selectInput(inputId = "Pos", "Position:", 
                  choices = c('Safety' = c('S', 'FS', 'SS'), 'Cornerback' = 'CB', 'Defensive Back' = 'DB', 'Defensive End' = 'DE', 'Fullback' = 'FB', 'Free Safety' = 'FS', 'Kicker' = 'K', 'Return Specialist' = 'KR', 'Punter' = 'P'),
      hr(),
      helpText('Any notes we need to put about the selections')
    ),
    
    mainPanel(
      plotlyOutput("Plot")  
    )
    
  )
))