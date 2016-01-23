library(shiny)
 
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Super Rugby betting"),
        
        # Sidebar with a slider input for team selection, home & away wager amounts
        sidebarLayout(
                sidebarPanel(
                        img(src = "s15_image.jpg", height = 72, width = 72, align = "right"),
                        p("This application shows the cumulative result of betting on a specific team over the last 7 seasons. It shows how team odds were over- or underestimated by bookmakers during this period. WARNING: use for retrospective analysis, not for predictions"),
                        selectInput("Team.Selected",
                                    "Select a Team:",
                                    c("Blues","Brumbies","Bulls","Cheetahs","Chiefs","Crusaders","Force",     
                                      "Highlanders", "Hurricanes", "Kings", "Lions", "Rebels", "Reds", "Sharks",    
                                      "Stormers", "Waratahs"),
                                    "Blues"),
                        
                        
                        sliderInput("Home.Wager",
                                    "Choose HOME game wager amount:",
                                    min = 0,
                                    max = 100,
                                    value = 100),
                        
                        sliderInput("Away.Wager",
                                    "Choose AWAY game wager amount:",
                                    min = 0,
                                    max = 100,
                                    value = 100),
                        
                        br(),
                        p("Data was sourced from ",
                          a("Australia Sports Betting ", 
                            href = "http://www.aussportsbetting.com/data/"), 
                          " website and is being used for personal reasons only.")
                ),
                
                # Show a plot, summary and data table of selected team
                
                mainPanel(
                        tabsetPanel(
                                tabPanel("Plot", plotOutput("outcomePlot")),
                                tabPanel("Table", dataTableOutput("table"))
                        )
                )
                
        )
)
)
