library(shiny)
library(plotly)
library(dplyr)

shinyUI(fluidPage(    
  
  titlePanel("Player Statistics Scatter Plot"),
  
  sidebarLayout(      
    
    # sidebarPanel(
    #   selectInput(inputId = "GenPos", 
    #               label = 'Position:', 
    #               choices = c('Quarterback' = 'QB', 'Running Back' = 'RB', 'Tight End' = 'TE', 'Wide Receiver' = 'WR', 'Fullback' = 'FB'), 
    #               selected = 'Quarterback'),
    #   conditionalPanel(
    #     condition = "input.GenPos == 'QB'",
    #           selectInput(inputId = 'Stat', 
    #                       label = 'Statistic:', 
    #                       choices = c('Pass Completions' = 'Cmp', 'Pass Attempts' = 'Pass_Att', 'Passing Yards' = 'Pass_Yds', 'Pass Interceptions' = 'Pass_Int', 'Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Rushing Touchdowns' = 'Rush_Tds'), 
    #                       selected = 'Passing Yards')
    #     ),
    #   conditionalPanel(
    #           condition = "input.GenPos == 'RB' | input.GenPos == 'FB' | input.GenPos == 'WR'",
    #           selectInput(inputId = 'Stat',
    #                       label = 'Statistic:',
    #                       choices = c('Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Rushing Touchdowns' = 'Rush_Tds', 'Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'),
    #                       selected = 'Rushing Yards')
    #   )
    # ),
    sidebarPanel(
      #Select Position Type
      selectInput(inputId = "Team",
                  label = "Position Type:",
                  choices = c('Offense' = 'Offense', 'Defense' = 'Defense'),
                  selected = 'Offense'),
      #If the Position Type is Offense and Position is QB
      conditionalPanel(
        condition = "input.Team == 'Offense'",
        selectInput(inputId = 'GenPos',
                    label = 'Position:',
                    choices = c('Quarterback' = 'QB', 'Running Back' = 'RB', 'Tight End' = 'TE', 'Wide Receiver' = 'WR', 'Fullback' = 'FB'),
                    selected = 'Quarterback'),
        conditionalPanel(
          condition = "input.GenPos == 'QB'",
          selectInput(inputId = 'Stat',
                      label = 'Statistic:',
                      choices = c('Pass Completions' = 'Cmp', 'Pass Attempts' = 'Pass_Att', 'Passing Yards' = 'Pass_Yds', 'Pass Interceptions' = 'Pass_Int', 'Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Rushing Touchdowns' = 'Rush_Tds'),
                      selected = 'Passing Yards')
        ),
        #Changes statistics if Position is RB, FB, or WR
        conditionalPanel(
          condition = "input.GenPos == 'RB' | input.GenPos == 'FB' | input.GenPos == 'WR'",
          selectInput(inputId = 'Stat',
                      label = 'Statistic:',
                      choices = c('Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Rushing Touchdowns' = 'Rush_Tds', 'Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'),
                      selected = 'Rushing Yards')
        ),
        #Changes statistics if Position is TE
        conditionalPanel(
          condition = "input.GenPos == 'TE'",
          selectInput(inputId = 'Stat',
                      label = 'Statistic:',
                      choices = c('Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'),
                      selected = 'Receiving Yards')
        )
      ),
      #Changes Statistics of Position Type is Defense and adds Positions and Statistics since all stats are the same for these positions
      conditionalPanel(
        condition = "input.Team == 'Defense'",
        selectInput(inputId = 'GenPos',
                    label = 'Position:',
                    choices = c('Safety' = 'S', 'Cornerback' = 'CB', 'Defensive End' = 'DE', 'Linebacker' = 'LB', 'Defensive Tackle' = 'NT'),
                    selected = 'Cornerback'),
        selectInput(inputId = 'Stat',
                    label = 'Statistic:',
                    choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'),
                    selected = 'Tackles')
      ),
      hr(),
      helpText('Any notes we need to put about the selections')
    ),
    mainPanel(
      plotlyOutput("statPlot")
    )
  )
))
