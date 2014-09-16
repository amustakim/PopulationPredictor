shinyUI(fluidPage(
   #use different font for the title (headerPanel)
   tags$head(
                tags$style(HTML("@import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                h1 {
                        font-family: 'Lobster', cursive;
                        font-weight: 500;
                        line-height: 1.1;
                        color: #48ca3b;
                   }
               "))
            ),
   
   headerPanel("US Population Predictor"),
    
    mainPanel(
        
            
        sliderInput('yr', 
                    label="Select a year: ",
                    value = 2020, 
                    min = 2014, 
                    max = 2040, 
                    step = 1,
                    format='####',
                    width='250px'
                    ),
        
        p("and see the population predicted for that year below,
           using data points from the last 34 years (1980 - 2013) and 
           a simple linear regression method:"),
        
        plotOutput('popTrends')
        
    ),
   
   sidebarPanel ("Historical US population in millions from 1980 - 2013 (data from usgovernmentspending.com):",
                 tableOutput('table')
           )
))
