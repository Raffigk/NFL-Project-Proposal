library(dplyr)

# Scatterplot that maps position to type of statistic, based on round pick
#setwd("~/Desktop/INFO201/NFL-Project-Proposal")
full.draft.data <- read.csv('data/Final_Draft_Data.csv', stringsAsFactors = FALSE)
#Data for this chart
draft.data <- full.draft.data %>% 
  select(Year, Rnd, Pick, Player, Pos, Cmp, Pass_Att, Pass_Yds, Pass_Int, Rush_Att, Rush_Yds, Rush_TDs, Rec, Rec_Yds, Rec_Tds, Tkl, Def_Int, Sk)

defense.team <- c('DT', 'DE', 'DB', 'MLB', 'OLB', 'CB', 'S', 'FS', 'ILB', 'DL', 'SS', 'LB')
offense.team <- c('C', 'G', 'T', 'QB', 'RB', 'WR', 'TE', 'OL', 'NT', 'FB')
special.team <- c('K', 'H', 'LS', 'P', 'KOS', 'KR', 'PR')

# Takes in a position to determine which team a player is on 
GetTeam <- function(pos) {
  if (length(grep(pos, defense.team)) != 0) {
    team = 'Defense'
  } else if (length(grep(pos, offense.team)) != 0) {
    team = 'Offense'
  } else if (length(grep(pos, special.team)) != 0) {
    team = 'Special Teams'
  } else {
    team = NULL
  }
  return (team)
}

# Add column to dataframe that includes specific positions
draft.data <- draft.data %>% 
  mutate(Team= (lapply(draft.data$Pos, GetTeam)))

#Adding column to make calculations easier
Agg_Position <- function(pos) {
  if (pos == 'LB' | pos == 'MLB' | pos == 'ILB' | pos == 'OLB') {
    new.pos = 'LB'
  } else if (pos == 'S' | pos == 'SS' | pos == 'FS') {
    new.pos = 'S'
  } else if (pos == 'CB' | pos == 'DB') {
    new.pos = 'CB'
  } else {
    new.pos = pos
  }
  return(new.pos)
}

# Because some positions are very specific, add a column to the dataframe that provides a generalized position for each player
draft.data <- draft.data %>%
  mutate(GenPos = (lapply(draft.data$Pos, Agg_Position)))


# scatterplot: x axis = set of years from 1985-2015 (30 pts for each statistic)
# user selects position and statistic
# each datapoint represents one year
# calculate average of statistic per year
# y axis = statistic 


