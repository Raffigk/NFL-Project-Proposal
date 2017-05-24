library(dplyr)

official.names.data <- read.csv('data/NFLUniversities.csv')
lat.long.data <- read.csv('data/UniversitiesLatLong.csv')
colnames(lat.long.data)[1] <- 'Official.Name'
official.lat.long <- full_join(official.names.data, lat.long.data, by='Official.Name')
official.draft.data <- read.csv('data/nfl_draft.csv')

CombineData <- function(univ.name) {
  draft.data <- filter(official.draft.data, College.Univ == univ.name)
  lat.long.data <- filter(official.lat.long, College.Univ == univ.name)
  final.data <- full_join(draft.data, lat.long.data, by='College.Univ')
}

full.draft.data <- lapply(as.character(official.draft.data$College.Univ), CombineData) %>% bind_rows()
write.csv(full.draft.data, file = 'Final_Draft_Data.csv', row.names = FALSE)
