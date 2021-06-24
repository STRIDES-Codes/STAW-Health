library(shiny)
library(leaflet)
library(tigris)
library(tidyverse)
library(sf)
library(DT)

df <- read_csv('final_data.csv')

states <- states(cb = TRUE)

map_df1 <- geo_join(states, df, "NAME", "state", how = "inner")

mytheme <- theme(
  panel.border = element_blank(),
  panel.grid.major = element_line(color = 'grey60', linetype = 'dashed',
                                  size = 0.5),
  panel.grid.minor = element_blank(),
  panel.background = element_rect(colour = "white", fill = "white"),
  legend.position = "top", axis.line = element_line(colour = "white"),
  text = element_text(family = "Palatino Linotype", color = 'grey5'),
  axis.text.x = element_text(colour = "grey5", size = 10),
  axis.text.y = element_text(colour = "grey5", size = 10,),
  axis.ticks = element_line(colour = "grey5"),
  title = element_text(colour = 'grey5', size = 10, vjust = -4))