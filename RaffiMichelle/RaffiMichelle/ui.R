library(shiny)
library(plotly)
library(dplyr)

shinyUI(fluidPage(    
  
  titlePanel("Player Statistics Scatter Plot"),
  
  sidebarLayout(
    sidebarPanel(
      # #Backup Code
      selectInput(inputId = 'GenPos', 'Position:', choices = c('Quarterback (O)' = 'QB', 'Running Back (O)' = 'RB', 'Tight End (O)' = 'TE', 'Wide Receiver (O)' = 'WR', 'Fullback (O)' = 'FB', 'Cornerback (D)' = 'CB', 'Defensive End (D)' = 'DE', 'Linebacker (D)' = 'LB', 'Defensive Tackle (D)' = 'NT'), selected = 'Quarterback'),
      uiOutput('selectedStats'),
      hr(),
      helpText("O: Offensive Position"),
      helpText("D: Defensive Position")
      
      #This code is problematic
      # selectInput(inputId = "Team", label = "Position Type:", choices = c('Offense', 'Defense'), selected = 'Offense'),
      # conditionalPanel(
      #   condition = "input.Team == 'Offense'",
      #   selectInput(inputId = 'GenPos', 'Position:', choices = c('Quarterback' = 'QB', 'Running Back' = 'RB', 'Tight End' = 'TE', 'Wide Receiver' = 'WR', 'Fullback' = 'FB'), selected = 'Quarterback')
      # ),
      # conditionalPanel(
      #   condition = "input.Team == 'Defense'",
      #   selectInput(inputId = 'GenPos', 'Position:', choices = c('Safety' = 'S', 'Cornerback' = 'CB', 'Defensive End' = 'DE', 'Linebacker' = 'LB', 'Defensive Tackle' = 'NT'), selected = 'Cornerback')
      #   #selectInput(inputId = 'Stat', 'Statistic:', choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'), selected = 'Tackles')
      # ),
      # uiOutput('selectedStats'),
      # hr(),
      # helpText('Any notes we need to put about the selections')
    ),
    mainPanel(
      plotlyOutput("statPlot")
    )
  )
))
