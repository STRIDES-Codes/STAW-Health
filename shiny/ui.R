
# Choices for drop-downs
states_select <- state.name
year_select <- df$year


navbarPage("STAW-Health", id="nav",
           tabsetPanel(
           tabPanel("The Map",
                    div(class="outer"),
                        leafletOutput("map", width="1200", height="800"),
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = "auto", left = "auto", right = 10, bottom = 35,
                                      width = 300, height = "auto",
                                      h2("Risk Explorer"),
                                      selectInput("state", "State", states_select),
                                      selectInput("year", "Year", unique(year_select), selected = 2020),
                        ),
           ),
           
           tabPanel("The Data",
                    plotOutput("plot2")
           )
        )
)