####################################
##
### DEVELOPED BY IGOR ALCANTARA
### igor.alcantara@ipc-global.com
### igoralcantara.com.br
##
###################################

library(shiny)

library(rCharts)

shinyUI(
  navbarPage("MLB Salaries and Achievements",
             tabPanel("Plot",
                sidebarPanel(
                      sliderInput("range", 
                                  "Season:", 
                                  min = 2000, 
                                  max = 2011, 
                                  value = c(2000, 2011),
                                  format="####"
                            ),
                      uiOutput("leaguesControls"),
                      uiOutput("teamsControls"),
                      actionButton(inputId = "clear_all", label = "Clear selection", icon = icon("check-square")),
                      actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square-o"))
                ),
             
             mainPanel(
               tabsetPanel(
                 tabPanel(p(icon("bar-chart-o"), "Performance"),
                          h5("It is recommended to narrow down the number of selections (by selection only a league, for example) to better visualize the plots.", align="center"),
                          h4('Regular Season Performance', align = "center"),
                          showOutput("WinsByTeam", "nvd3"),
                           h4('YTD Payroll (in Billion USD)', align = "center"),
                           showOutput("PayrollByTeam", "nvd3"),
                           h4('YTD Avg Salary (in Billion USD)', align = "center"),
                           showOutput("SalaryByTeam", "nvd3")

                 ),
                 
                 # Data 
                 tabPanel(p(icon("table"), "Data"),
                          dataTableOutput(outputId="table")
                 )
                 
                 
               )
             )
          ),
             
         tabPanel("About",
                  mainPanel(
                    includeMarkdown("about.md")
                  )
         )
         
    )
)
                          
                          
                          
