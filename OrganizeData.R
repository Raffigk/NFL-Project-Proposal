library(dplyr)

# Scatterplot that maps position to type of statistic, based on round pick

full.draft.data <- read.csv('data/Final_Draft_Data.csv', stringsAsFactors = FALSE)
#Data for this chart
draft.data <- full.draft.data %>% 
  select(Year, Rnd, Pick, Player, Pos, Cmp, Pass_Att, Pass_Yds, Pass_Int, Rush_Att, Rush_Yds, Rush_TDs, Rec, Rec_Yds, Rec_Tds, Tkl, Def_Int, Sk)

defense.team <- c('DT', 'DE', 'DB', 'MLB', 'OLB', 'CB', 'S', 'FS', 'ILB', 'DL', 'SS', 'LB')
offense.team <- c('C', 'G', 'T', 'QB', 'RB', 'WR', 'TE', 'OL', 'NT', 'FB')
special.team <- c('K', 'H', 'LS', 'P', 'KOS', 'KR', 'PR')


# Add column to dataframe that includes specific positions
draft.data <- draft.data %>% 
  mutate(Team= (lapply(draft.data$Pos, GetTeam)))


# Since some positions can be referred to general positions, RefinePos(pos) generalizes each specific position
RefinePos <- function(pos) {
  if (pos == 'MLB' | pos == 'ILB' | pos == 'OLB') {
    draft.data[pos] <- 'LB'
  } else if (pos == 'FS' | pos == 'SS') {
    draft.data[pos] <- 'S'
  } else if (pos == 'C' | pos == 'G' | pos == 'T' | pos == 'NT') {
    draft.data[pos] <- 'OL'
  }
}

NewPos <- function(pos) {
  if (pos == 'MLB' | pos == 'ILB' | pos == 'OLB') {
    draft.data$Position = 'LB'
  } else if (pos == 'FS' | pos == 'SS') {
    draft.data$Position = 'S'
  } else if (pos == 'C' | pos == 'G' | pos == 'T' | pos == 'NT') {
    draft.data$Position = 'OL'
  }
}

# Takes in a position to determine which team a player is on 
GetTeam <- function(pos) {
  if (length(grep(pos, defense.team)) == 0) {
    team = 'Defense'
  } else if (length(grep(pos, offense.team)) == 0) {
    team = 'Offense'
  } else if (length(grep(pos, special.team)) == 0) {
    team = 'Special Teams'
  } else {
    team = NULL
  }
  return (team)
}

length(grep('DFF', defense.team))

grep('DFF', defense.team)
gsub('DT', defense.team)
grepl('DT', defense.team)

#Computing Averages for Statistics



