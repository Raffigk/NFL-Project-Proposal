library(dplyr)

# Scatterplot that maps position to type of statistic, based on round pick

full.draft.data <- read.csv('data/Final_Draft_Data.csv', stringsAsFactors = FALSE)
draft.data <- full.draft.data %>% 
  select(Year, Rnd, Pick, Player, Pos, Cmp, Pass_Att, Pass_Yds, Pass_Int, Rush_Att, Rush_Yds, Rush_TDs, Rec, Rec_Yds, Rec_Tds, Tkl, Def_Int, Sk)


defense.team <- c('DT', 'DE', 'DB', 'MLB', 'OLB', 'CB', 'S', 'FS', 'ILB', 'DL', 'SS', 'LB')
offense.team <- c('C', 'G', 'T', 'QB', 'RB', 'WR', 'TE', 'OL', 'NT', 'FB')
special.team <- c('K', 'H', 'LS', 'P', 'KOS', 'KR', 'PR')

#MLB/ILB/OLB/LB
#FS/S/SS
#C/G/T/NT/OL


# Add column to dataframe that includes specific positions
draft.data <- lapply(draft.data$Pos, RefinePos)


# Since some positions can be referred to general positions, RefinePos(pos) generalizes each specific position
RefinePos <- function(pos) {
  if (pos == 'MLB' | pos == 'ILB' | pos == 'OLB') {
    draft.data[[pos]] = 'LB'
  } else if (pos == 'FS' | pos == 'SS') {
    draft.data[[pos]] = 'S'
  } else if (pos == 'C' | pos == 'G' | pos == 'T' | pos == 'NT') {
    draft.data[[pos]] = 'OL'
  }
}

test <- data.frame(one = c(1, 2, 4), two = c(1, 3, 4), three = c(2, 2, 5))
if test$one[1] == 1 



