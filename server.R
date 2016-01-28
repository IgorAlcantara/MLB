####################################
##
### DEVELOPED BY IGOR ALCANTARA
### igor.alcantara@ipc-global.com
### igoralcantara.com.br
##
###################################

library(shiny)
library(ggplot2)
library(rCharts)
library(data.table)
library(reshape2)
library(dplyr)
library(markdown)

source("appCode.R", local = TRUE)

appdata <- fread('Data/Baseball.csv') %>% 
  mutate(League = tolower(League)) %>% 
  mutate(Team = tolower(Team))  
#  na.omit()

leagues <- sort(unique(appdata$League))
teams <- sort(unique(appdata$Team))


shinyServer(function(input, output, session) {
  
  # Define and initialize reactive values
  values <- reactiveValues()
  values$leagues <- leagues
  values$teams <- teams
  
  output$leaguesControls <- renderUI({
    checkboxGroupInput('leagues', 'Leagues', leagues, selected=values$leagues)
  })
  
  output$teamsControls <- renderUI({
    checkboxGroupInput('teams', 'Teams', teams, selected=values$teams)
  })
  
  # Add observers on clear and select all buttons
  observe({
    if(input$clear_all == 0) return()
    values$teams <- c()
  })
  
  observe({
    if(input$select_all == 0) return()
    values$teams <- teams
  })
  

  appdata.wins.teams <- reactive({
    wins_by_season(appdata, input$range[1], input$range[2], input$leagues, input$teams)
  })
  
  output$WinsByTeam <- renderChart({
    plot_wins_by_team(appdata.wins.teams())
  })
  
  
  
  appdata.payroll.teams <- reactive({
    payroll_by_season(appdata, input$range[1], input$range[2], input$leagues, input$teams)
  })
  
  output$PayrollByTeam <- renderChart({
    plot_payroll_by_team(appdata.payroll.teams())
  })
  
  
  appdata.avg.sal.teams <- reactive({
    avg_salary_by_season(appdata, input$range[1], input$range[2], input$leagues, input$teams)
  })
  
  output$SalaryByTeam <- renderChart({
    plot_avg_sal_by_team(appdata.avg.sal.teams())
  })
  
  
  
  dataTable <- reactive({
    aggregate_by_team(appdata, input$range[1], input$range[2], input$leagues, input$teams)
  })
  
  output$table <- renderDataTable(
    {dataTable()}, options = list(bFilter = FALSE, iDisplayLength = 50))
  
  

})
