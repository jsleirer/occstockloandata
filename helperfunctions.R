# Helper functions

# Combines url, date, and format to download csv files
url_generator <- function(prefix, date, suffix){
  url_occ <- paste0(prefix, date, suffix)
  return(url_occ)
}


# Function to make a sequence of weekdays (potential trading days) 
seq_weekdays <- function(start_date, end_date, date_format){
  
  # Creates a sequence of dates from start and end
  days_all <- seq(as.Date(start_date, format = date_format),
                as.Date(end_date, format = date_format),
                by = "1 day")
  # Now exlcude weekends
  days_weekday <- days_all[! weekdays(days_all) %in% c("Saturday", "Sunday")]

  # Convert to appropriate format
  days_weekday <- days_weekday %>% format(date_format)
  return(days_weekday)
}

# Check if trading day is holiday
# Works by checking if the csv is empty.  
is_holiday <- function(csv){
  if (nrow(csv) == 0) return(TRUE)
  else return(FALSE)
}

