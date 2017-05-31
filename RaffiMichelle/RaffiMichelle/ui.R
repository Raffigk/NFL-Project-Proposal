library(shiny)
library(plotly)
library(dplyr)

shinyUI(fluidPage(    
  
  titlePanel("Player Statistics Scatter Plot"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "Team", label = "Position Type:", choices = c('Offense', 'Defense'), selected = 'Offense'),
      conditionalPanel(
        condition = "input.Team == 'Offense'",
        selectInput(inputId = 'GenPos', 'Position:', choices = c('Quarterback' = 'QB', 'Running Back' = 'RB', 'Tight End' = 'TE', 'Wide Receiver' = 'WR', 'Fullback' = 'FB'), selected = 'Quarterback')
      ),
      conditionalPanel(
        condition = "input.Team == 'Defense'",
        selectInput(inputId = 'GenPos', 'Position:', choices = c('Safety' = 'S', 'Cornerback' = 'CB', 'Defensive End' = 'DE', 'Linebacker' = 'LB', 'Defensive Tackle' = 'NT'), selected = 'Cornerback')
        #selectInput(inputId = 'Stat', 'Statistic:', choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'), selected = 'Tackles')
      ),
      uiOutput('selectedStats'),
      hr(),
      helpText('Any notes we need to put about the selections')

      #Backup Code
      # selectInput(inputId = 'GenPos', 'Position:', choices = c('Quarterback' = 'QB', 'Running Back' = 'RB', 'Tight End' = 'TE', 'Wide Receiver' = 'WR', 'Fullback' = 'FB','Safety' = 'S', 'Cornerback' = 'CB', 'Defensive End' = 'DE', 'Linebacker' = 'LB', 'Defensive Tackle' = 'NT'), selected = 'Quarterback'),
      # uiOutput('selectedStats')
    ),
    mainPanel(
      plotlyOutput("statPlot")
    )
  )
))
