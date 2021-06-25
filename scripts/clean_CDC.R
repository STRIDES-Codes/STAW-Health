# import and clean cdc data

# load packages
library(tidyverse)

# function to clean an individual text file
clean_files <- function(file) {
  # import each line as string, lines is character vector
  lines <- read_lines(file, skip_empty_rows = FALSE, progress = interactive())
  
  # temp stores lines as dataframe
  temp <- lines %>% tibble()
  names(temp) = "lines"
  temp %<>% rowwise() %>% mutate(lines = str_replace_all(lines, "\x97", "NA"))
  
  # get row numbers of data and select
  ind_1 <- which(temp == "tab delimited data:")
  ind_2 <- which(str_starts(temp$lines, "U.S. Virgin Islands"))
  data <- temp[(ind_1+1):ind_2,1]
  
  # list of column names
  colnames <- temp[4:(ind_1-2),1] %>% rowwise() %>%
    mutate(lines = str_replace_all(lines, "<sup>NA</sup>", ""),
           lines = str_replace_all(lines, "\\*", ""),
           lines = trimws(lines))
  colnames[[1,1]] = "ReportingArea"
  
  # separate column to columns
  data_s <- data %>% separate(col = lines, sep = "\t", into = letters[1:nrow(colnames)])
  names(data_s) <- deframe(colnames)
  
  # add year column
  yr <- basename(file) %>% str_extract("\\d{4}")
  data_s <- data_s %>% mutate(Year = yr)
  
  # fix 2019 Reported Area column
  data_s <- data_s %>%
    mutate(ReportingArea = replace(ReportingArea,
                                   ReportingArea == "U.S. Residents, excluding U.S. Territories",
                                   "United States"))
  
  # add region column
  data_s <- data_s %>% mutate(Region = case_when(
    ReportingArea %in% c("North Carolina", "Virginia", "Kentucky", "Tennessee",
                         "West Virginia", "Connecticut", "Maine", "Massachusetts",
                         "New Hampshire", 
                         "Rhode Island", "Vermont", "Delaware", "Maryland",
                         "New Jersey", "Pennsylvania") ~ "EAST",
    ReportingArea %in% c("Arkansas", "Louisiana", "Mississippi", "Alabama",
                         "Georgia", "South Carolina", "Florida") ~ "SOUTHEAST",
    ReportingArea %in% c("Illinois", "Indiana", "Ohio", "Iowa", "Missouri",
                         "Kansas", "Nebraska", "North Dakota", "South Dakota",
                         "Michigan", "Minnesota", "Wisconsin") ~ "MIDWEST",
    ReportingArea %in% c("Arizona", "New Mexico", "Oklahoma", "Texas") ~ "SOUTHWEST",
    ReportingArea %in% c("Idaho", "Montana", "Wyoming", "Colorado", "Nevada",
                         "Utah", "Oregon", "Washington") ~ "NORTHWEST",
    ReportingArea %in% c("California") ~ "CALIFORNIA",
    ReportingArea %in% c("United States", "New England", "Middle Atlantic",
                         "East North Central", "West North Central", "South Atlantic",
                         "District of Columbia", "East South Central", "West South Central",
                         "Mountain", "Pacific", "Alaska", "Hawaii", "Territories",
                         "American Samoa", "Commonwealth of Northern Mariana Islands",
                         "Guam", "Puerto Rico", "U.S. Virgin Islands",
                         "New York City", "New York (excluding New York City)") ~ "OTHER")) %>%
    select(ReportingArea, Region, Year, !c(ReportingArea, Region, Year))
  
  # replace string "NA" with Na
  data_s <- data_s %>% mutate(across(!c(ReportingArea:Year), ~na_if(., "NA")))
  
  # convert data to integer
  data_s <- data_s %>% mutate(across(!c(ReportingArea:Region), ~str_replace_all(., ",", "")))
  data_s <- data_s %>% mutate(across(!c(ReportingArea:Region), ~as.integer(.)))
  
  # create row for New York
  nyrow <- data_s %>% filter(str_detect(ReportingArea, "New York")) %>% 
    summarise(., across(where(is.numeric), sum), across(where(is.character), ~.)) %>% 
    head(1) %>% select(c(ReportingArea, Region), !c(ReportingArea, Region)) %>% 
    mutate(ReportingArea = "New York", Year = as.integer(yr), Region = "EAST")
  
  # add row to end of df
  data_s <- bind_rows(data_s, nyrow)
  
  return(data_s)
}

# file to clean
filelist <- list.files(path = "~/Spatial-forecasting-of-environmental-infectious-diseases-within-vulnerable-populations/data/cdc/raw_data_files/",
                       recursive = TRUE,
                       full.names = TRUE)

# list of dataframes
df_list <- lapply(filelist, clean_files)
names(df_list) <- filelist

# join 2016 data
df_2016 <- full_join(df_list[[1]], df_list[[2]], by = c("ReportingArea", "Region", "Year")) %>% 
  full_join(., df_list[[3]], by = c("ReportingArea", "Region", "Year"))

# join 2017 data
df_2017 <- full_join(df_list[[4]], df_list[[5]], by = c("ReportingArea", "Region", "Year")) %>% 
  full_join(., df_list[[6]], by = c("ReportingArea", "Region", "Year"))

# join 2018 data
df_2018 <- full_join(df_list[[7]], df_list[[8]], by = c("ReportingArea", "Region", "Year")) %>% 
  full_join(., df_list[[9]], by = c("ReportingArea", "Region", "Year"))

# join 2019 data
df_2019 <- full_join(df_list[[10]], df_list[[11]], by = c("ReportingArea", "Region", "Year")) %>% 
  full_join(., df_list[[12]], by = c("ReportingArea", "Region", "Year")) %>% 
  full_join(., df_list[[13]], by = c("ReportingArea", "Region", "Year"))

clean_CDC <- bind_rows(df_2016, df_2017, df_2018, df_2019)

write_csv(clean_CDC,
          file = "~/Spatial-forecasting-of-environmental-infectious-diseases-within-vulnerable-populations/data/cdc/clean_CDC.csv")

clean_CDC_short <- clean_CDC %>%
  select(ReportingArea:Year, Campylobacteriosis, `Cryptosporidiosis, Total`, `Lyme disease, Total`, `Dengue virus infections, Dengue`, Malaria, Cyclosporiasis)

write_csv(clean_CDC_short,
          file = "~/Spatial-forecasting-of-environmental-infectious-diseases-within-vulnerable-populations/data/cdc/clean_CDC_short.csv")
