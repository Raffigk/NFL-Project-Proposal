library(dplyr)

official.names.data <- read.csv('data/NFLUniversities.csv', stringsAsFactors = FALSE)
lat.long.data <- read.csv('data/UniversitiesLatLong.csv', stringsAsFactors = FALSE)
colnames(lat.long.data)[1] <- 'Official.Name'
official.lat.long <- full_join(official.names.data, lat.long.data, by='Official.Name') %>% filter(College.Univ != '')
official.draft.data <- read.csv('data/nfl_draft.csv')
full.draft.data <- full_join(official.draft.data, official.lat.long, by='College.Univ')
write.csv(full.draft.data, file = 'Final_Draft_Data.csv', row.names = FALSE)

# Data Gathering for the map data
names(lat.long.data) <- c("Official.Name", "LONGITUDE", "LATITUDE")
individual.colleges <- left_join(x = lat.long.data, y = official.names.data, by = "Official.Name") %>% 
  filter(!is.na(College.Univ)) 
nfl.map.data <- full.draft.data %>% 
  select(Player, Year, Rnd, Pos, Official.Name) %>% 
  filter(Year >= 2005)
count.player.per.college <- full.draft.data %>% 
  count(Official.Name)
map.college.data <- left_join(x = count.player.per.college, y = individual.colleges, by = "Official.Name") %>%
  filter(X.1 != "")




write.csv(map.college.data, file = "Data/map.college.data.csv", row.names = FALSE)
players.college.data <- left_join(x = map.college.data, y = nfl.map.data, by = "Official.Name")
write.csv(players.college.data, file = "Data/map.player.data.csv", row.names = FALSE)

