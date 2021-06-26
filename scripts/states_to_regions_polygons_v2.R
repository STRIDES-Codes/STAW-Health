library(tigris)
library(leaflet)
library(sf)
library(dplyr)
library(sp)
library(htmlwidgets)

# get states
states <- states()

# check regions 
#unique(states$REGION)

# read in states to regions file
states_regions <- read.csv("data/cdc/states_to_regions.csv", header=TRUE)
# read in data
df <- read.csv("data/final_data.csv")
# fix new york
states_regions$location[which(states_regions$location == "New York (excluding New York City)")] <- "New York"

# subset to year and disease
df_sub <- df[df$year == 2018 & df$disease == "Lyme",]
# remove state column
df_sub$state <- NULL
# remove duplicate rows
df_sub <- distinct(df_sub)
# keep max risk score for each region
df_max <- df_sub %>% group_by(region) %>% top_n(1, risk_score_avg)

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
region_polygons <- c(california, east, midwest, northwest, southeast, southwest)
# create dataframe of region names
#region_names <- data.frame(region = c("CALIFORNIA", "EAST", "MIDWEST", "NORTHWEST", "SOUTHEAST", "SOUTHWEST"))

# create a simple feature collection
regions <- st_sfc(region_polygons)
# add region names and create a sf object
#regions_df <- st_sf(region_names , regions)

# sort by region
df_max <- df_max[order(df_max$region),]
# merge regions_df with df_max
final_df <- st_sf(df_max, regions)


# color palette for choropleth
pal <- colorNumeric(palette = "RdYlBu", domain = final_df$num_cases,
                    n = 6, reverse = T)

disease_map <- leaflet(final_df) %>% 
  setView(-96, 37.8, 4) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(final_df$num_cases),
              color = NA,
              group = "Disease",
              label = paste("cases of", final_df$disease,
                            ": ",
                            final_df$num_cases)) %>% 
  addPolylines(color = "blue", weight = 2.0) %>%
  addLegend(pal = pal,
            values = ~num_cases,
            group = "Disease",
            position = "bottomleft",
            title = "Reported Cases")



# save as file
#write.csv(regions,"regions.csv", row.names = FALSE)
# save html of map
htmlwidgets::saveWidget(disease_map, "lyme_2018.html")


# reference: https://cengel.github.io/R-spatial/intro.html#the-sf-package
