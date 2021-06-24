#### Finalized data ####
library(tidyverse)

NAWS <- read.csv("./data/NAWS/final_NAWS.csv") %>% 
  dplyr::select(-starts_with("X"))
NOAA <- read.csv("./data/NOAA/NOAA_climate_aggregate.csv") %>% 
  dplyr::select(-starts_with("X"))
CDC <- read.csv("./data/cdc/clean_CDC_short.csv")

# Re-coding NAWS years & renaming variables
NAWS_clean <- NAWS %>%
  mutate(year=case_when(FY==2013~2016,
                        FY==2014~2017,
                        FY==2015~2018,
                        FY==2016~2018, TRUE~NA_real_),
         region=case_when(REGION6==1~"EAST",
                         REGION6==2~"SOUTHEAST",
                         REGION6==3~"MIDWEST",
                         REGION6==4~"SOUTHWEST",
                         REGION6==5~"NORTHWEST",
                          REGION6==6~"CALIFORNIA", TRUE~NA_character_)) %>%
  rename(., risk_score_avg = MEAN_RISK, count_workers = NUM_WORKERS) %>%
  dplyr::select("region","year", "risk_score_avg", "count_workers")

NOAA_clean <- NOAA %>%
  filter("region_name" != "OTHER") %>%
  rename(., year = DATE,region = region_name, weather_temp_avg = region_temp, weather_prcp_avg = region_prcp) %>%
  dplyr::select("region", "year","weather_temp_avg", "weather_prcp_avg") %>%
  .[!duplicated(.), ]

NAWS_NOAA <- left_join(NAWS_clean, NOAA_clean, by = c("region", "year"))

# Final cleaning of CDC
CDC_clean <- CDC %>%
  group_by(Region, Year) %>%
  mutate(Camp=sum(Campylobacteriosis, na.rm=T),
         Crypto=sum(Cryptosporidiosis..Total, na.rm=T),
         Lyme=sum(Lyme.disease..Total, na.rm=T),
         Dengue=sum(Dengue.virus.infections..Dengue, na.rm=T),
         Malaria2=sum(Malaria, na.rm=T),
         Cyclo=sum(Cyclosporiasis, na.rm=T)) %>%
  dplyr::select("Region", "Year", "Camp":"Cyclo") %>%
  filter(Region != "OTHER",!is.na(Region)) %>%
  .[!duplicated(.), ] %>%
  rename(., region=Region, year=Year, Campylobacteriosis=Camp, Cryptosporidiosis=Crypto, Malaria=Malaria2, Cyclosporiasis=Cyclo)

CDC_clean <- CDC_clean %>%
  pivot_longer(
    cols= Campylobacteriosis:Cyclosporiasis,
    names_to = "disease",
    values_to = "num_cases"
  )

final_data <- left_join(CDC_clean, NAWS_NOAA, by = c("region", "year"))
write_csv(final_data, "./data/final_data.csv")
