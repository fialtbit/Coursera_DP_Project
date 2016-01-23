library(shiny)
library(downloader)
library(dplyr)
library(xlsx)
library(ggplot2)

## Download and read data 
URL <- "http://www.aussportsbetting.com/historical_data/super_rugby.xlsx"
if(!file.exists("super_rugby.xlsx")) {
        download(URL, "super_rugby.xlsx", mode = "wb")}
dat <- read.xlsx2("super_rugby.xlsx", sheetName = "Data", startRow = 2, colIndex = c(1,3:6,8:10),
                  colClasses = c("Date", "character", "character", "numeric", "numeric", "numeric","numeric","numeric"))

# Clean and order data
dat <- dat[complete.cases(dat),]
dat <- dat[order(dat$Date),]


shinyServer(function(input, output) {
        
        # Create output plot
        output$outcomePlot <- renderPlot({
                
                # Filter data for selected team
                dat <- filter(dat, Home.Team == input$Team.Selected | Away.Team == input$Team.Selected)
                
                # Determine the result of the match
                dat$Result <- ifelse(dat$Home.Team == input$Team.Selected & dat$Home.Score > dat$Away.Score, "Win",
                                     ifelse(dat$Away.Team == input$Team.Selected & dat$Away.Score > dat$Home.Score, "Win",
                                            ifelse(dat$Home.Team == input$Team.Selected & dat$Home.Score < dat$Away.Score, "Lose",
                                                   ifelse(dat$Away.Team == input$Team.Selected & dat$Away.Score < dat$Home.Score, "Lose","Draw"))))
                
                # Calculate the outcome of bet placed
                dat$Outcome <- ifelse(dat$Home.Team == input$Team.Selected & dat$Home.Score > dat$Away.Score, input$Home.Wager * dat$Home.Odds - input$Home.Wager,
                                      ifelse(dat$Away.Team == input$Team.Selected & dat$Away.Score > dat$Home.Score, input$Away.Wager * dat$Away.Odds - input$Away.Wager,
                                             ifelse(dat$Home.Team == input$Team.Selected & dat$Home.Score <= dat$Away.Score, -1 * input$Home.Wager,
                                                    ifelse(dat$Away.Team == input$Team.Selected & dat$Away.Score <= dat$Home.Score, -1* input$Away.Wager,0))))
                
                # Calculate the cumulative outcome over all years
                dat$Cum.Outcome <- cumsum(dat$Outcome)
                
                #Create the plot
                p1 <- ggplot(dat, aes(Date, Cum.Outcome)) + geom_line() + geom_point(aes(color = Result), size = 5) +
                                theme_bw() + ggtitle("Cumulative results of betting") + ylab("Profit / (Loss)") + xlab("Date")
                
                return(p1)
        })
        

        # Create searchable & sortable data table for reference
        output$table <- renderDataTable({
                dat <- filter(dat, Home.Team == input$Team.Selected | Away.Team == input$Team.Selected)
                dat})
        
})
