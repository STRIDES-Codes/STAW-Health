library(tigris)
library(leaflet)
library(sf)
library(dplyr)
library(sp)

# get states
states <- states()

# check regions 
#unique(states$REGION)

# read in states to regions file
states_regions <- read.csv("data/cdc/states_to_regions.csv", header=TRUE)
# fix new york
states_regions$location[which(states_regions$location == "New York (excluding New York City)")] <- "New York"

#### MIDWEST ####
# list of midwest states
midwest_states_list <- states_regions[states_regions$region_name == "MIDWEST",]$location
# subset to midwest states
midwest_states <- states[states$NAME %in% midwest_states_list,]
# merge state polygons
midwest <- st_union(midwest_states)
# plot state polygons
#plot(midwest_states)
#plot region polygon
#plot(midwest)

#### SOUTHEAST ####
# list of states
southeast_states_list <- states_regions[states_regions$region_name == "SOUTHEAST",]$location
# subset to states
southeast_states <- states[states$NAME %in% southeast_states_list,]
# merge state polygons
southeast <- st_union(southeast_states)
#plot(southeast)

#### SOUTHWEST ####
# list of states
southwest_states_list <- states_regions[states_regions$region_name == "SOUTHWEST",]$location
# subset to states
southwest_states <- states[states$NAME %in% southwest_states_list,]
# merge state polygons
southwest <- st_union(southwest_states)
#plot(southwest)

#### EAST ####
# list of states
east_states_list <- states_regions[states_regions$region_name == "EAST",]$location
# subset to states
east_states <- states[states$NAME %in% east_states_list,]
# merge state polygons
east <- st_union(east_states)
#plot(east)

#### NORTHWEST ####
# list of states
northwest_states_list <- states_regions[states_regions$region_name == "NORTHWEST",]$location
# subset to states
northwest_states <- states[states$NAME %in% northwest_states_list,]
# merge state polygons
northwest <- st_union(northwest_states)
#plot(northwest)

#### CALIFORNIA ####
california <- states[states$NAME == "California",]$geometry
#plot(california)

# create list of regions
region_polygons <- c(northwest, california, east, southwest, southeast, midwest)
# create list of region names
names <- c("northwest", "california", "east", "southwest", "southeast", "midwest")

# create dataframe
regions <- data.frame(names, region_polygons)
#plot(regions$geometry)

# create leaflet map
# m <- leaflet() %>%
#   setView(-96, 37.8, 4) %>% # United States
#   addTiles() %>%
#   addPolygons(data = regions$geometry,
#               label = regions$names,
#               labelOptions = labelOptions(
#                 style = list("font-weight" = "normal", padding = "3px 8px"),
#                 textsize = "15px",
#                 direction = "auto"))


# save as file
#write.csv(regions,"regions.csv", row.names = FALSE)
