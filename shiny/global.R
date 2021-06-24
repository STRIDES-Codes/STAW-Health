library(shiny)
library(leaflet)
library(tigris)
library(tidyverse)
library(sf)
library(DT)


df <- data.frame(rbind(data.frame(state = state.name,
                                  cholera=rexp(50),
                                  year = 2018, 
                                  pop = sample(1000, 50)),
                       data.frame(state = state.name,
                                  cholera=rexp(50),
                                  year = 2019,
                                  pop = sample(1000, 50)),
                       data.frame(state = state.name,
                                  cholera=rexp(50),
                                  year = 2020,
                                  pop = sample(1000, 50))))

states <- states(cb = TRUE)

map_df1 <- geo_join(states, df, "NAME", "state", how = "inner")