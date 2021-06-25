
shinyServer(function(input, output) {
# Map #

        map_df_sub <- reactive({
        subset(map_df1, year == input$year & disease == input$disease)
                })

        df_sub <- reactive({
        subset(df, year == input$year)
                })

        output$map <- renderLeaflet({
                pal <- colorNumeric(palette = 'RdYlBu', domain = map_df_sub()$num_cases,
                                    n = 50, reverse = T)
                map_df_sub() %>% 
                        leaflet() %>%
                        addProviderTiles("OpenStreetMap.HOT") %>%
                        setView(lng = -93.85, lat = 35.45, zoom = 4) %>% 
                        addLayersControl(baseGroups = c("OpenStreetMap.HOT"),
                                          overlayGroups = c("Disease"))
                        
        })
        
        observe({
                pal <- colorNumeric(palette = 'RdYlBu', domain = map_df_sub()$num_cases,
                                    n = 50, reverse = T)
                leafletProxy("map", data = map_df_sub()) %>% 
                        removeShape("Disease") %>%
                        clearControls() %>% 
                        addPolygons(fillColor = ~pal(num_cases),
                                    color = NA,
                                    group = 'Disease',
                                    label = paste("cases of", map_df_sub()$disease,
                                                  ": ",
                                                  map_df_sub()$num_cases)) %>% 
                        addPolylines(color = 'grey', weight = 0.5) %>%
                        addLegend(pal = pal,
                                  values = ~num_cases,
                                  group = "Disease",
                                  position = "bottomleft",
                                  title = 'Reported Cases')
                
                        # addCircleMarkers(lng = -93.85,
                        #                  lat = 25.45,
                        #                  radius = 10)
        })
                
        
        output$plot2<-renderPlot({
                df %>%
                        ggplot(aes(x=year,y=risk_score_avg))+
                        geom_point(aes(fill = region, size = count_workers),
                                   color = 'grey25',
                                   shape = 21) +
                        facet_wrap(~region) +
                        ylab("Average Risk Score") +
                        mytheme}
                ,height = 400,width = 600)
})
