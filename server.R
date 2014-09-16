library(XML)

getPop <- function() {
        #Get the population data from the Internet and parse it out 
        #into a data.frame called Pop, then format it's columns
        theurl <- "http://www.usgovernmentspending.com/download_multi_year_1980_2013USb_14c2li101mcn_20s"
        tables <- readHTMLTable(theurl)
        n.rows <- unlist(lapply(tables, function(t) dim(t)[1]))
        tables[[which.max(n.rows)]]
        x <- tables$"Government Spending ChartFiscal Years 1980 to 2013"
        Pop <- head(x[,c(1,3)], 34, stringsAsFactors = FALSE)
        colnames(Pop) <- c("Year","Population (in millions)")
        Pop$Year <- round(as.numeric(levels(Pop$Year))[Pop$Year])
        Pop$"Population (in millions)" <- as.numeric(levels(Pop$"Population (in millions)"))[Pop$"Population (in millions)"]
        return (Pop)
        
}

#Get cached data from the Internet 
#(to save time from reloading data over and over again)
Pop <<- getPop()

shinyServer(
    function(input, output) {
            
       output$table <- renderTable({
                    Pop
            },digits=0)
            
        output$popTrends <- renderPlot({
            
            #Render the scatterplot for 34 years worth of data
            #from 1980 to 2013:
            plot(Pop, 
                 col="blue", 
                 pch=5,  
                 main='US Population trends', 
                 ylim=c(0,400), 
                 xlim=c(1980,2040))
            
            #Add a regression trendline
            fit <- lm(Pop$"Population (in millions)"~Pop$Year)
            abline(fit ,
                   col="red", 
                   lwd=1, 
                   lty=1)
                        
            #Produce a green dotted line on the plot 
            #that corresponds to the input year
            yr <- input$yr 
            abline(v=yr,col="forestgreen",lty=3)

            #Calculate the correlation coefficient of the regression line
            #c <- cor(Pop$Year, Pop$"Population (in millions)")
            
            #Get the linear equation of the regresssion line
            # y = slope (x) + intercept
            intercept <- coef(fit)["(Intercept)"][[1]]
            slope <- coef(fit)["Pop$Year"][[1]]
            
            #Calculate the predicted value 
            #for a given input year using the linear equation
            pred <- ( slope * yr ) + intercept
            
            
            #Add legends
            legend('topleft', 
                   c("Actual data points (usgovernmentspending.com)", 
                     #paste("Regression line (correlation coefficient", round(c,4), ")" ),
                     paste("Regression line (y =", round(slope,2), "x", round(intercept,2),")" ),
                     "The year you selected"), 
                   col=c('blue','red','forestgreen'),
                   pch=c(5,NA,NA),
                   lty=c(NA,1,3),
                   bty='o',
                   cex=1
            )
            

            
            #Add annotation for the predicted value 
            #at the point of intersection between the vertical green line 
            #and the red regression line
            text(yr-15, 
                 pred-100, 
                 col="red", 
                 bty="l",
                 bg="white",
                 cex=3,
                 paste(round(pred,1),"million in ",yr))

        })        
    }
)