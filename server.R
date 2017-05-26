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
  select(Year, Rnd, Pos, Pos, Official.Name, LONGITUD, LATITUDE) %>% 
  filter(Year >= 2005)

count.player.per.college <- nfl.data %>% 
  count(Official.Name)

final.college.data <- left_join(x = individual.colleges, y = count.player.per.college, by = "Official.Name")



nfl.map<- final.college.data %>%
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
                          L.Point(40, 40) });}"))),
    
    label = paste0(strwrap(final.college.data$Official.Name), ": ", strwrap(final.college.data$n), " NFL players drafted") ,
    
    lng = (as.numeric(final.college.data$LONGITUDE)), lat = (as.numeric(final.college.data$LATITUDE)), icon = makeIcon(
      iconUrl = final.college.data$X.1,
      iconWidth = 40, iconHeight = 30)) %>% 
  addTiles()

nfl.map
library(dplyr)
library(shiny)
library(leaflet)

nfl.data <- 