m1 <- subset(map_df1, year == 2018 & disease == 'Malaria')

pal <- colorNumeric(palette = 'RdYlBu', domain = m1$count_workers,
                    n = 50, reverse = T)
m1 %>%
  leaflet() %>%
  addTiles() %>%
  setView(lng = -93.85, lat = 37.45, zoom = 4) %>% 
  addPolygons(fillColor = ~pal(count_workers), color = NA) %>% 
  addPolylines(color = 'grey', weight = 0.5)

  pal <- colorNumeric(palette = 'RdYlBu', domain = map_df1$cholera,
                      n = 50, reverse = T)
  map_df1 %>%
    leaflet() %>%
    addTiles() %>%
    setView(lng = -93.85, lat = 37.45, zoom = 4) %>% 
    addPolygons(fillColor = ~pal(cholera), color = NA) %>% 
    addPolylines(color = 'grey', weight = 0.5)
  