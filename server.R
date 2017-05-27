library(dplyr)
library(shiny)
library(leaflet)
library(stringr)

nfl.data <- read.csv("Data/Final_Draft_Data.csv", stringsAsFactors = FALSE)
all.lat.long <- read.csv("Data/UniversitiesLatLong.csv", stringsAsFactors = FALSE) 

names(all.lat.long) <- c("Official.Name", "LONGITUDE", "LATITUDE")
all.nfl.colleges <- read.csv("Data/NFLUniversities.csv", stringsAsFactors = FALSE)

individual.colleges <- left_join(x = all.lat.long, y = all.nfl.colleges, by = "Official.Name") %>% 
  filter(!is.na(College.Univ)) 

nfl.map.data <- nfl.data %>% 
  select(Player, Year, Rnd, Pos, Official.Name) %>% 
  filter(Year >= 2005)

count.player.per.college <- nfl.data %>% 
  count(Official.Name)

map.college.data <- left_join(x = individual.colleges, y = count.player.per.college, by = "Official.Name") %>% 
  filter(!is.na("X.1"))
players.college.data <- left_join(x = almost.college.data, y = nfl.map.data, by = "Official.Name")


nfl.map<- map.college.data %>%
  leaflet() %>%
  addTiles() %>%
  setView(lng = -114.805089, lat = 35.3327636, zoom = 3) %>%
  addMarkers(clusterOptions = markerClusterOptions(iconCreateFunction=JS(
    iconCreateFunction=JS("function (cluster) {    
                          var childCount = cluster.getChildCount(); 
                          var c = ' marker-cluster-';  
                          c += 'small';  
                          return new L.DivIcon({ html: 
                          '<div><span>' + childCount + '</span></div>', 
                          className: 'marker-cluster' + c, iconSize: new 
                          L.Point(40, 40)});}"))),
    
    label = paste0(strwrap(map.college.data$Official.Name), ": ", strwrap(map.college.data$n), " NFL players drafted") ,
    
    lng = (as.numeric(map.college.data$LONGITUDE)), lat = (as.numeric(map.college.data$LATITUDE)), icon = makeIcon(
      iconUrl = map.college.data$X.1,
      iconWidth = 50, iconHeight = 40)) %>% 
  addTiles()

nfl.map
