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
  colnames <- temp[4:(ind_1-2),1] %>%
    rowwise() %>% mutate(lines = str_replace_all(lines, "<sup>NA</sup>", ""), lines = trimws(lines))
  
  # separate column to columns
  data_s <- data %>% separate(col = lines, sep = "\t", into = letters[1:nrow(colnames)])
  names(data_s) <- deframe(colnames)
  
  return(data_s)
}

# file to clean
filelist <- list.files(path = "~/Spatial-forecasting-of-environmental-infectious-diseases-within-vulnerable-populations/data/cdc/raw_data/",
                       recursive = TRUE,
                       full.names = TRUE)

# list of dataframes
df_list <- lapply(filelist, clean_files)
names(df_list) <- filelist
