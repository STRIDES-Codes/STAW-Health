
shinyServer(function(input, output) {
# Map #

#map_df1 <- geo_join(states, df, "NAME", "state", how = "inner")

        map_df_sub <- reactive({
        subset(map_df1, year == input$year)
                })

        df_sub <- reactive({
        subset(df, year == input$year)
                })

        output$map <- renderLeaflet({
                pal <- colorNumeric(palette = 'RdYlBu', domain = map_df_sub()$cholera,
                                    n = 50, reverse = T)
                map_df_sub() %>% 
                        leaflet() %>%
                        addProviderTiles("OpenStreetMap.HOT") %>%
                        setView(lng = -93.85, lat = 25.45, zoom = 4) #%>% 
                        # addLayersControl(baseGroups = c("OpenStreetMap.HOT"),
                        #                  overlayGroups = c("Cholera"))
                        
        })
        
        observe({
                pal <- colorNumeric(palette = 'RdYlBu', domain = map_df_sub()$cholera,
                                    n = 50, reverse = T)
                leafletProxy("map", data = map_df_sub()) %>% 
                        # removeShape("Cholera") %>%
                        # clearControls() %>% 
                        addPolygons(fillColor = ~pal(cholera),
                                    color = NA) %>% 
                        addPolylines(color = 'grey', weight = 0.5)
        })
                
        
        output$plot2<-renderPlot({
                df %>%
                        ggplot(aes(x=pop,y=cholera))+
                        geom_point(colour='grey33')}
                ,height = 400,width = 600)
})
