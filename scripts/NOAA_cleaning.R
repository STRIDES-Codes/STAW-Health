#######################################
##  Cleaning Climate Data from NOAA  ##
#######################################

library(here)
library(data.table)
library(usdata)
library(tidyverse)

here::here()

## States to regions data ##
states_to_regions <- read.csv("data/NOAA/states_to_regions.csv") %>% dplyr::select(-starts_with("X"))

## Weather data ##
## Data from:
# - https://www.ncei.noaa.gov/data/gsoy/archive/
# - https://www.ncdc.noaa.gov/cdo-web/webservices
# - https://www.ncdc.noaa.gov/cdo-web/
## May be helpful:
# - https://www.ncei.noaa.gov/thredds/satellite/satellite.html
# - https://www.ncei.noaa.gov/support/access-data-service-api-user-documentation

## Making list of files in NOAA GSoY, filtering to only US, & making a new csv: 
station_list <- untar('../scratch/gsoy-latest.tar.gz', list = TRUE)
station_list <- station_list[grep(pattern = "US", station_list)]

station_list2 <- station_list[1:7000]
station_list3 <- station_list[7001:14000]
station_list4 <- station_list[14001:21000]
station_list5 <- station_list[21001:28000]
station_list6 <- station_list[28001:32889]

untar('../scratch/gsoy-latest.tar.gz',  files=station_list2, exdir = "../scratch/gsoy/")
untar('../scratch/gsoy-latest.tar.gz',  files=station_list3, exdir = "../scratch/gsoy/")
untar('../scratch/gsoy-latest.tar.gz',  files=station_list4, exdir = "../scratch/gsoy/")
untar('../scratch/gsoy-latest.tar.gz',  files=station_list5, exdir = "../scratch/gsoy/")
untar('../scratch/gsoy-latest.tar.gz',  files=station_list6, exdir = "../scratch/gsoy/")

climate_list <- list.files(path="../scratch/gsoy/", full.names = TRUE, recursive = TRUE)
climate.csv <- lapply(climate_list, read.csv)

climate <- rbindlist(climate.csv, fill = TRUE)
climate_clean <- climate %>%
  dplyr::select(-contains("ATTRIBUTES")) %>%
  dplyr::select("STATION":"NAME", "EMXP", "PRCP", "EMNT", "EMXT", "TAVG":"TMIN") %>%
  filter(DATE %in% c(2014,2015,2016,2017,2018,2019)) %>%
  filter(!is.na(PRCP) & !is.na(TAVG))
# Data dictionary: https://www.ncei.noaa.gov/data/gsoy/doc/GSOY_documentation.pdf
# EMXP: Highest daily total of precipitation in the year. In millimeters.
# PRCP: Total annual precipitation. In millimeters. 
# EMNT: Extreme minimum temp for year. Lowest daily min temp for the year. In C.  
# EMXT: Extreme max temp for year. Highest daily max temp for the year. In C. 
# TAVG [TMAX, TMIN]: Average Annual [max, min] temperature. In C. 

# Extracting states from weather station names
climate_clean <- climate_clean %>%
  separate(NAME, c("name1", "state1"), ",", remove=FALSE) %>%
  mutate(state1 = trimws(state1, which = "both")) %>%
  separate(state1, c("state_ab", "US"), " ") %>%
  mutate(state_ab = trimws(state_ab, which = "both"),
         state = abbr2state(state_ab)) %>%
  dplyr::select(-"name1",-"US",-"state_ab")

climate_clean <- left_join(climate_clean, states_to_regions, by=c("state"="location"))

# Changing C to F for Temp, mm to in for Prcp
ctof <- function(c){
  f <- (c*(9/5))+32
}

climate_clean <- climate_clean %>%
  mutate(temp_f=ctof(TAVG),
         prcp_in=PRCP/25.4)

# Creating aggregate variables
climate_aggregate <- climate_clean %>% 
  group_by(state, DATE) %>%
  mutate(state_prcp=mean(prcp_in),
         state_temp=mean(temp_f)) %>%
  group_by(region_name, DATE) %>%
  mutate(region_prcp=mean(prcp_in),
         region_temp=mean(temp_f))

climate_aggregate <- climate_aggregate %>%
  dplyr::select("DATE", "state", "region_name", "state_prcp":"region_temp")

climate_aggregate <- climate_aggregate[!duplicated(climate_aggregate), ] %>%
  filter(DATE %in% c(2016,2017,2018,2019))

write.csv(climate_clean, "./data/NOAA/NOAA_climate_data.csv", row.names = TRUE)
write.csv(climate_aggregate, "./data/NOAA/NOAA_climate_aggregate.csv", row.names = TRUE)