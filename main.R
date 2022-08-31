#  Script to download daily OCC stock loan data (individual daily csv's)
#  And combine into single dataframe

# Required libraries and other files
library(dplyr)
source("helperfunctions.R")

# Parameters
start_date  <- "01/01/2020" 
end_date <- "08/26/2022"
#end_date <- "01/07/2020"
format <- "%m/%d/%Y"
occwebsite_prefix <- "https://marketdata.theocc.com/stock-loan-bal-by-security?dailyDate="
occwebsite_suffix <- "&format=csv"

# Initialize dataframe
dat_occ <- data.frame(Symbol = character(),
                      "Market Loan Loan Balance" = numeric(),
                      "Hedge Loan Balance" = numeric(),
                      Date = character())


# Step 1: Create sequence of Dates
weekdays <- seq_weekdays(start_date, end_date, format)

# Step 2:  For every date do the following
# make a url for that date
# download the csv and remove whitespace
# check if the csv has any data (i.e isn't a trading holiday)
# Delete mystery column
# Filter only for desired stock (GME)
# Add date to DF
# Combine the data  frame to the previous dataframe
# Drop the non-combined data
# Pause so not blocked by website for making for making too many downloads

for(i in 1:length(weekdays)){
  print(c("i is ", i))
  print(c("length of weekdays is ", length(weekdays)))
  # make a url for that date
  url_occ <- url_generator(occwebsite_prefix, weekdays[i], occwebsite_suffix)
  print(url_occ)
  # download the csv, also want to remove white space
  dat_daily <- read.csv(url_occ, strip.white = TRUE)
  str(dat_daily)
  # Check if csv has any data
  if(is_holiday(dat_daily)) next
  # Drop mystery column from data
  dat_daily <- dat_daily %>% select(-X)
  # Filter only for GME stock
  dat_daily <- dat_daily %>% filter(Symbol == "GME")
  # Add Date to daily data
  dat_daily <- dat_daily %>% mutate(Date = weekdays[i])
  # Combine daily data with existing df
  dat_occ <- bind_rows(dat_occ,dat_daily)
  str(dat_occ)
  # Drop daily data 
  rm(dat_daily)
  # Pause
  Sys.sleep(1)
}
