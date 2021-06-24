
# Choices for drop-downs
disease_select <- df$disease 
year_select <- df$year


navbarPage("STAW-Health", id="nav",
           tabsetPanel(
           tabPanel("The Map",
                    div(class="outer"),
                        leafletOutput("map", width="1200", height="500"),
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = "auto", left = "auto", right = 20, bottom = 35,
                                      width = 300, height = "auto",
                                      h2("Risk Explorer"),
                                      selectInput("disease", "Disease", unique(disease_select), selected = 'Malaria'),
                                      selectInput("year", "Year", unique(year_select), selected = 2020),
                        ),
           ),
           
           tabPanel("The Data", align = 'center',
                    plotOutput("plot2")
           )
        )
)