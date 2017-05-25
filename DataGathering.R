library(dplyr)

official.names.data <- read.csv('data/NFLUniversities.csv', stringsAsFactors = FALSE)
lat.long.data <- read.csv('data/UniversitiesLatLong.csv', stringsAsFactors = FALSE)
colnames(lat.long.data)[1] <- 'Official.Name'
official.lat.long <- full_join(official.names.data, lat.long.data, by='Official.Name') %>% filter(College.Univ != '')
official.draft.data <- read.csv('data/nfl_draft.csv')
full.draft.data <- full_join(official.draft.data, official.lat.long, by='College.Univ')
write.csv(full.draft.data, file = 'Final_Draft_Data.csv', row.names = FALSE)
