####################################
##
### DEVELOPED BY IGOR ALCANTARA
### igor.alcantara@ipc-global.com
### igoralcantara.com.br
##
###################################


#' Aggregate dataset by state
#' 
#' @param dt data.table
#' @param year_min integer
#' @param year_max integer
#' @param leagues character vector
#' @param teams character vector
#' @return data.table
#'
aggregate_by_team <- function(dt, year_min, year_max, leagues, teams) {

  newDT <- data.table(Year=sort(unique(dt$Year)), League=sort(unique(dt$League)), Team=sort(unique(dt$Team)))

  aggregated <- dt %>% filter(Year >= year_min, Year <= year_max, Team %in% teams, League %in% leagues) %>% 
    group_by(League, Team, Year) %>%
    summarise_each(funs(sum), Wins, Payroll, AvgSalary) %>%
    arrange(League, Team, Year)
  
  
  finalDT <- left_join(newDT,  aggregated, by = c("League", "Team", "Year"))
  #finalDT$Payroll <- format(finalDT$Payroll, scientific = FALSE, digits = 2)
  finalDT
  
}



wins_by_season <- function(dt, year_min, year_max, leagues, teams) {
  # Filter
  dt %>% filter(Year >= year_min, Year <= year_max, League %in% leagues, Team %in% teams) %>%
    # Group and aggregate
    group_by(Year, Team) %>% 
    summarise(totWins = sum(Wins)) %>%
    #summarise_each(funs(sum), Wins) %>%
    arrange(Year, Team)
  
}

payroll_by_season <- function(dt, year_min, year_max, leagues, teams) {
  to_billion <- function(x) x/1000000
  
  # Filter
  dt %>% filter(Year >= year_min, Year <= year_max, League %in% leagues, Team %in% teams) %>%
    # Group and aggregate
    group_by(Year, Team) %>% 
    #summarise(totPayroll = sum(Payroll)) %>%
    summarise_each(funs(sum), Payroll) %>%
    mutate_each(funs(to_billion), Payroll) %>%
    arrange(Year, Team)
  
}

avg_salary_by_season <- function(dt, year_min, year_max, leagues, teams) {
  to_billion <- function(x) x/1000000
  
  # Filter
  dt %>% filter(Year >= year_min, Year <= year_max, League %in% leagues, Team %in% teams) %>%
    # Group and aggregate
    group_by(Year, Team) %>% 
    summarise_each(funs(sum), AvgSalary) %>%
    mutate_each(funs(to_billion), AvgSalary) %>%
    arrange(Year, Team)
  
}


#' Prepare plot of number of events by year
#'
#' @param dt data.table
#' @param dom
#' @param yAxisLabel
#' @return plot
plot_wins_by_team <- function(dt, dom = "WinsByTeam", yAxisLabel = "Wins") {
  WinsByTeam <- nPlot(
    totWins ~ Year,
    data = dt,
    type = "stackedAreaChart", 
    group = "Team",
    dom = dom, 
    width = 650
  )
  
  WinsByTeam$chart(margin = list(left = 100))
  WinsByTeam$yAxis(axisLabel = yAxisLabel, width = 80)
  WinsByTeam$xAxis(axisLabel = "Year", width = 70)
  WinsByTeam
  
}

#' Prepare plot of number of events by year
#'
#' @param dt data.table
#' @param dom
#' @param yAxisLabel
#' @return plot
plot_payroll_by_team <- function(dt, dom = "PayrollByTeam", yAxisLabel = "Payroll (in Billion USD)") {
  PayrollByTeam <- nPlot(
    Payroll ~ Year,
    data = dt,
    type = "stackedAreaChart", 
    group = "Team",
    dom = dom, 
    width = 650
  )
  
  PayrollByTeam$chart(margin = list(left = 100))
  PayrollByTeam$yAxis(axisLabel = yAxisLabel, width = 120)
  #PayrollByTeam$yAxis(tickFormat="#!d3.format(',.1f')!#")
  PayrollByTeam$xAxis(axisLabel = "Year", width = 70)
  PayrollByTeam
  
}


#' Prepare plot of number of events by year
#'
#' @param dt data.table
#' @param dom
#' @param yAxisLabel
#' @return plot
plot_avg_sal_by_team <- function(dt, dom = "SalaryByTeam", yAxisLabel = "Avg Salary") {
  SalaryByTeam <- nPlot(
    AvgSalary ~ Year,
    data = dt,
    type = "stackedAreaChart", 
    group = "Team",
    dom = dom, 
    width = 650
  )
  
  SalaryByTeam$chart(margin = list(left = 100))
  SalaryByTeam$yAxis(axisLabel = yAxisLabel, width = 80)
  SalaryByTeam$xAxis(axisLabel = "Year", width = 70)
  SalaryByTeam
  
}


