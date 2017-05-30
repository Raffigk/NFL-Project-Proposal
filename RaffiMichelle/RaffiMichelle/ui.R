library(shiny)
library(plotly)
library(dplyr)

shinyUI(fluidPage(    
  
  titlePanel("Player Statistics Scatter Plot"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput(inputId = "Team",
                  label = "Position Type:",
                  choices = c('Offense', 'Defense'),
                  selected = 'Offense'),
      
      conditionalPanel(
        condition = "input.Team == 'Offense'", 
        selectInput(inputId = 'GenPos', 'Position:', choices = c('Quarterback' = 'QB', 'Running Back' = 'RB', 'Tight End' = 'TE', 'Wide Receiver' = 'WR', 'Fullback' = 'FB'), selected = 'Quarterback'),
        conditionalPanel(
          condition = "input.GenPos == 'QB'",
          selectInput(inputId = 'Stat', 'Statistic:', choices = c('Pass Completions' = 'Cmp', 'Pass Attempts' = 'Pass_Att', 'Passing Yards' = 'Pass_Yds', 'Pass Interceptions' = 'Pass_Int', 'Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Rushing Touchdowns' = 'Rush_Tds'), 
                      selected = 'Passing Yards')
        ),
        #Changes statistics if Position is RB, FB, or WR
        conditionalPanel(
          condition = "input.GenPos == 'RB' | input.GenPos == 'FB' | input.GenPos == 'WR'",
          selectInput(inputId = 'Stat', 'Statistic:', choices = c('Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Rushing Touchdowns' = 'Rush_Tds', 'Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'), 
                      selected = 'Rushing Yards')
        ),
        #Changes statistics if Position is TE
        conditionalPanel(
          condition = "input.GenPos == 'TE'",
          selectInput(inputId = 'Stat', 'Statistic:', choices = c('Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'), 
                      selected = 'Receiving Yards')
        )
      ),
        
      #If the Position Type is Defense
      conditionalPanel(
        condition = "input.Team == 'Defense'",
        selectInput(inputId = 'GenPos', 'Position:', choices = c('Safety' = 'S', 'Cornerback' = 'CB', 'Defensive End' = 'DE', 'Linebacker' = 'LB', 'Defensive Tackle' = 'NT'), 
                    selected = 'Cornerback'),
        selectInput(inputId = 'Stat', 'Statistic:', choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'), selected = 'Tackles')
      ),
    
      
      hr(),
      helpText('Any notes we need to put about the selections')
    ),
    
    
  mainPanel(
      plotlyOutput("statPlot")
  )
)
))
