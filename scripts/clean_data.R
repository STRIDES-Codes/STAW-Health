# import and clean cdc data

# load packages
library(tidyverse)

temp <- read_tsv("~/Spatial-forecasting-of-environmental-infectious-diseases-within-vulnerable-populations/data/cdc/raw_data/lyme/2019-table2j.txt",
         col_names = FALSE,
         skip_empty_rows = FALSE)

# ind_col1 <- which(temp$X1 == "column labels in same order that data fields appears in each record below:")

ind_1 <- which(temp$X1 == "tab delimited data:")
ind_2 <- which(temp$X1 == "U.S. Virgin Islands")

df <- read_tsv("~/Spatial-forecasting-of-environmental-infectious-diseases-within-vulnerable-populations/data/cdc/raw_data/lyme/2019-table2j.txt",
               skip = 15, col_names = FALSE, skip_empty_rows = FALSE)