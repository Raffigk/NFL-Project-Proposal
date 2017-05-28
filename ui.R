
# INFO 201 Group Final Project
# Michelle Ho, Raffi Gharakhanian, Jon Cantle, Josh Dugger
library(shiny)
library(leaflet)
library(shinythemes)
library(dplyr)

shinyUI(fluidPage(theme = shinytheme("superhero"), 
                  # A map comparing location with round/position/year
                  tabsetPanel(
                    
                    tabPanel("Intro Page",
                             titlePanel("NFL statistics"),
                             h4("Michelle Ho, Raffi Gharakhanian, Jon Cantle, Josh Dugger"),
                             h3("The Data"),
                             p("We discovered a data set containing information on NFL
                               players drafted from the years 1985 to 2015, ",
                               a("here(ERROR)", href = "https://www.kaggle.com/ronaldjgrafjr/nfl-draft-outcome"),
                               ". This dataset was originally created by Ron Graf, who collected the data from ",
                               a("pro football reference", href = "http://www.pro-football-reference.com/"),
                               ", a NFL players statistics website."), 
                             p("In addition to that data set, we will also be using a data set that gives
                               us information about the location of all colleges in the United States, found ",
                               a("here", href ="https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx"),
                               "(the data set titled
                               “Directory Information(cant find this, need better directions”). "),
                             h3("Inspirations to look deeper"),
                             p("With the NFL being such a popular sport. There were plenty of unanswered 
                               questions that could be answered through out data sets."),
                             p("Some questions we thought could be answered and provide interesting results were:"),
                             p("- Which colleges produce the best NFL players (based on which round they were picked)
                               for each position?"),
                             p("- Is there a relationship between the college location and strength of position for
                               a particular player?"),
                             p("- What different characteristics (college, location, round picked in, year picked)
                               affect the statistics the player has throughout their career?"),
                             mainPanel(
                               verbatimTextOutput("intro page")
                             )
                             ),
                  tabPanel("Map",
  
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
                  choices = c('Offense' = 'Offense', 'Defense' = 'Defense', 'Both' = 'Both'),
                  selected = 'Both'),
      #If the team type is both, select all positions
      conditionalPanel(
        condition = "input.Team == 'Both'",
        selectInput(inputId = 'Pos', "Position:",
                    choices = c('All' = 'All'),
                    selected = 'All')
      ),
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
    ),
    # Conclusion panel, where seen results are noted.
    tabPanel("Conclusion",
      
      mainPanel(
        verbatimTextOutput("conclusion"))
    )
  )
)
)

#conditionalPanel(
# condition = "input.Pos == 'S'", #| input.Pos == 'CB' | input.Pos == 'DE' | input.Pos == 'LB' | input.Pos == 'NT'",
# selectInput(inputId = 'Statistic', 'Statistic:', choices = c('Tackles' = 'Tkl', 'Defensive Interceptions' = 'Def_Int', 'Sacks' = 'Sk'), selected = 'Tackles')
#),
