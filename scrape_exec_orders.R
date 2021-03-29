# Scrapes executive orders signed by the governor and turns them into structured data for use by the TrentonTracker API

library(rvest)
library(dplyr)
library(lubridate)

# Get governor's EO website
content <- read_html('https://nj.gov/infobank/eo/056murphy/approved/eo_archive.html') %>%
  html_table(fill = TRUE, header = TRUE)

# Construct a data frame from the scraped table, parse the dates
execorders <- data.frame(number = content[[1]][1], subject = content[[1]][2], date = content[[1]][3]) %>% 
  rename('Number' = 'No.') %>% mutate(Date.Issued = ymd(Date.Issued)) %>% 
  rename('Date' = "Date.Issued")

# Generate URL for full text download EO-77.pdf
baseurl <- "https://nj.gov/infobank/eo/056murphy/pdf/"
execorders$URL <- paste0(baseurl,"EO-",execorders$Number,".pdf")

# Write out the scraped data
write.csv(execorders,'execorders.csv',row.names = FALSE)