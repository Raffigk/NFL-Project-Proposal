# INFO 201 Group Final Project
# Michelle Ho, Raffi Gharakhanian, Jon Cantle, Josh Dugger
library(shiny)
library(leaflet)
library(shinythemes)
library(dplyr)
library(plotly)

# source('./scripts/OrganizeDraftData.R')

shinyUI(
  fluidPage(
    theme = shinytheme("united"),
    tabsetPanel(
      # gives a summary of our data collection and what we will be presenting.
      
      tabPanel(
        "Intro Page",
        titlePanel("NFL statistics"),
        h4("Michelle Ho, Raffi Gharakhanian, Jon Cantle, Josh Dugger"),
        
        hr(),
        
        h3("The Data"),
        p("We discovered a data set containing information on NFL players drafted from the 
          years 1985 to 2015, see full dataset ", 
          a("here", href = "https://www.kaggle.com/ronaldjgrafjr/nfl-draft-outcomes"),
          ". This dataset was originally created by Ron Graf, who collected the data from ",
          a("Pro Football Reference,", href = "http://www.pro-football-reference.com/"),
          " a NFL players statistics website."), 
        p("In addition to that data set, we will also be using a data set that gives
          us information about the location of all colleges in the United States. This dataset
          was found from the ",
          a("National Center for Education Statistics", href ="https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx"),
          "We will be using this data set to map each college that players in the NFL played at."),
      
        br(),
        
        h3("Our Audience"),
        p("Our primary target audience is sports networks who are interested in the trends and patterns of NFL draft 
          picks from 1985 to 2015. By providing sports networks with our data, our data will allow our particular 
          audience to supply unique and meaningful data to their viewers."),
        
        br(),
        
        h3("Inspirations to look deeper"),
        p("With the NFL Draft being such a popular cultural event, there were plenty of unanswered questions that we
          believed could be answered through our data sets."),
        p("Some questions we believe could be answered and could provide valuable results include:"),
        p("- Which colleges produce the best NFL players (based on which round they were picked)
          for each position?"),
        p("- Is there a relationship between the college location and strength of position for
          a particular player?"),
        p("- What different characteristics (college, location, round picked in, year picked"),
        p("- How the year the player was picked, and the years they played in,
          affect the statistics the player has throughout their career?"),
        
        br(),
        
        h3("Displaying our Findings/ Our Data Visualizations:"),
        p("In order to answer the questions listed above, we created data visualizations that visually represent the 
          answers."),
        br(),
        
        h4("Map of colleges"),
        p("We created a map of all the colleges in the United States that had players drafted from
          in the years 2000 - 2015. Our aim was to see visible differences in which colleges showed up 
          when we filtered our data by different factors. These factors included the range of rounds 
          picked, the range of years picked, and the position players were getting drafted for."),
        p("From this, we will be able to derive insights into which college football programs send the most 
          players to the NFL. We will also be able to assess whether specific positions or specific years
          have been more successful at specific colleges. "),
        
        h4("Scatter plot of player statistics"),
        p("We believe that the NFL has changed drastically over the past few decades. These changes have resulted
          in the game being played differently, resulting in priorities changing, and ultimitely statistics mutating."),
        p("We created a scatter plot that plots how the statistics change over the years of the NFL, with
          options to choose between position and type of statistic. We expect to see trends either moving 
          upwards or downwards in a few different statistic groups as time moves forward."),
        mainPanel(
          verbatimTextOutput("intro page")
        )
      ),
      
      # A map comparing location with round/position/year
      tabPanel("Map",
        titlePanel(h1("Where Do Draft Picks Come From?", align = 'center')),
        sidebarLayout(
          sidebarPanel(
          #User input a player name 
          textInput("player", label = h5("Player select"), value = "", width = NULL,
            placeholder = "Choose a player"),
          helpText("For example : Aaron Rodgers"),
          hr(),
          conditionalPanel( condition = "input.player == ''",
            #Slider for year selector
            sliderInput(inputId = "Year", "Choose the Year(s)",
              min = 1985, max = 2015, value = c(1985, 2015), sep = ""),
            #Slider for round selector
            sliderInput(inputId = "round", "Choose the Round(s)",
              min = 1, max = 12,  value = c(1, 12), sep = ""),
            #Select Team Type
            selectInput(inputId = "GenPos", "Position:", choices = c('Quarterback(O)' = 'QB', 'Running Back(O)' = 'RB', 'Tight End(O)' = 'TE',
                                                                  'Wide Receiver(O)' = 'WR', 'Fullback(O)' = 'FB', 'Center(O)' = 'C',"Guard(O)" = 'G','Tackle(O)' = 'T',
                                                                  'Kicker(ST)'= 'K','Punter(ST)' = 'P','Long Snapper(O)' = 'LS','Cornerback(D)' = 'CB', 
                                                                  'Defensive End(D)' = 'DE', 'Linebacker(D)' = 'LB', 'Defensive Tackle(D)' = 'NT',
                                                                  'All' = 'All'), selected = "All")
  

        
          ),
          hr(),
          helpText("Data for years 1993/2003 missing from dataset")
        ),
        mainPanel(
          leafletOutput("map"),
          br(),
          p('We created this map to visualize draft picks across universities in the United States. Using the 
            widgets in the side panel, one can change the data being displayed on the map by year range or round,
            or specify a position type and position to analyze. One can even search for a specific NFL player 
            in the text box.')
        )
      )
    ),
    
    #  Scatterplot displaying player position statistic per year
    tabPanel("Scatter Plot",
             titlePanel(h1("Player Statistics Scatter Plot", align = 'center')),
             sidebarLayout(
               sidebarPanel(
                 selectInput(inputId = 'GenPos', 'Position:', 
                             choices = c('Quarterback (O)' = 'QB', 'Running Back (O)' = 'RB', 'Tight End (O)' = 'TE', 
                                         'Wide Receiver (O)' = 'WR', 'Fullback (O)' = 'FB', 'Cornerback (D)' = 'CB', 
                                         'Defensive End (D)' = 'DE', 'Linebacker (D)' = 'LB', 'Defensive Tackle (D)' = 'NT'), 
                             selected = 'Quarterback'),
                 uiOutput('selectedStats'),
                 hr(),
                 helpText("O: Offensive Position"),
                 helpText("D: Defensive Position"),
                 helpText("Note: any unavailable data points are due to gaps in the original data")
               ),
               mainPanel(
                 plotlyOutput("statPlot"),
                 br(),
                 p('The scatter plot above displays the average statistics for a specific position and statistic for each
                   year from 1985 to 2015. In other words, given a specific position and statistic, the average statistics
                   for all players careers drafted in the given year are displayed on the plot. Using the widgets in the side panel, 
                   one can change the position and statistic being analyzed to change the data on the scatterplot.')
               )
             )
      
    ),
    
    # Conclusion panel, where seen results are noted.
    tabPanel("Conclusion",
             titlePanel("Our Findings"),
             hr(),
             
             h3('Major Trends'),
             p('We were able to discover that the way NFL players play have noticeably changed since 1985. For example, 
               from our scatter plot, on average, all quarterback passing statistics have gone up, while all running 
               back statistics have gone down. This reflects and proves the theory that passing has become more prevalent 
               in the game overtime. Thus, in answering our initial question, “Does the year the player was picked affect 
               the statistics the player has throughout their career?”, we are able to acknowledge that there is a relationship 
               between the year and player statistics.'),
             
             h3('Notable Outliers'),
             p('One notable outlier we noticed was that since 2010, the average amount of yards rushed by quarterbacks 
               has risen substantially. There are significant outliers that are present in our scatterplot from years 
               2010-2015, which shows that a large shift since 1985.'),
             
      mainPanel(
        verbatimTextOutput("conclusion"))
      )
    )
  )
)
 
