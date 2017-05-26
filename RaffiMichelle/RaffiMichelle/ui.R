library(shiny)

shinyUI(fluidPage(    
  
  titlePanel("Player Statistics Scatter Plot"),
  
  sidebarLayout(      
    
    sidebarPanel(
<<<<<<< HEAD
      selectInput(inputId = "Team", "Position Type:", 
                  choices = c('Offense' = 'Offense', 'Defense' = 'Defense', 'Special Teams' = 'Special Teams')),
      #Panel for Offense
=======
      #Select Position Type
      selectInput(inputId = "Team", "Position Type:", choices = c('Offense' = 'Offense', 'Defense' = 'Defense'), selected = 'Offense'),
      #If the Position Type is Offense and Position is QB
>>>>>>> Completed Scatter Plot UI
      conditionalPanel(
        condition = "input.Team == 'Offense'", 
        selectInput(inputId = 'Pos', 'Position:', choices = c('Quarterback' = 'QB', 'Running Back' = 'RB', 'Tight End' = 'TE', 'Wide Receiver' = 'WR', 'Fullback' = 'FB'), selected = 'Quarterback'),
        conditionalPanel(
          condition = "input.Pos == 'QB'",
          selectInput(inputId = 'Statistic', 'Statistic:', choices = c('Pass Completions' = 'Cmp', 'Pass Attempts' = 'Pass_Att', 'Passing Yards' = 'Pass_Yds', 'Pass Interceptions' = 'Pass_Int', 'Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Rushing Touchdowns' = 'Rush_Tds'), selected = 'Passing Yards')
        ),
        #Changes statistics if Position is RB, FB, or WR
        conditionalPanel(
          condition = "input.Pos == 'RB' | input.Pos == 'FB' | input.Pos == 'WR'",
          selectInput(inputId = 'Statistic', 'Statistic:', choices = c('Rush Attempts' = 'Rush_Att', 'Rushing Yards' = 'Rush_Yds', 'Rushing Touchdowns' = 'Rush_Tds', 'Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'), selected = 'Rushing Yards')
        ),
        #Changes statistics if Position is TE
        conditionalPanel(
          condition = "input.Pos == 'TE'",
          selectInput(inputId = 'Statistic', 'Statistic:', choices = c('Receptions' = 'Rec', 'Receiving Yards' = 'Rec_Yds', 'Receiving Touchdowns' = 'Rec_Tds'), selected = 'Receiving Yards')
        )
      ),
<<<<<<< HEAD
      selectInput(inputId = "Pos", "Position:", 
                  choices = c('Safety' = c('S', 'FS', 'SS'), 'Cornerback' = 'CB', 'Defensive Back' = 'DB', 'Defensive End' = 'DE', 'Fullback' = 'FB', 'Free Safety' = 'FS', 'Kicker' = 'K', 'Return Specialist' = 'KR', 'Punter' = 'P'),
=======
      #Changes Statistics of Position Type is Defense and adds Positions and Statistics since all stats are the same for these positions
      conditionalPanel(
        condition = "input.Team == 'Defense'",
        selectInput(inputId = 'P', 'Position:', choices = c('Safety' = 'S', 'Cornerback' = 'CB', 'Defensive End' = 'DE', 'Linebacker' = 'LB', 'Defensive Tackle' = 'NT'), selected = 'Cornerback'),
        selectInput(inputId = 'Statistic', 'Statistic:', choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'), selected = 'Tackles')
      ),
     
>>>>>>> Completed Scatter Plot UI
      hr(),
      helpText('Any notes we need to put about the selections')
    ),
    mainPanel(
      
    )
  )
))

#conditionalPanel(
 # condition = "input.Pos == 'S'", #| input.Pos == 'CB' | input.Pos == 'DE' | input.Pos == 'LB' | input.Pos == 'NT'",
 # selectInput(inputId = 'Statistic', 'Statistic:', choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'), selected = 'Tackles')
#),