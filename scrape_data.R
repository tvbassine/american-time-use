# Purpose: scrape data from the BLS website for the comparison between
# the 2019 and 2020 American time use survey.
# Date: 7/23/21
#######################################################################

# Load required packages:
library(rvest)
library(dplyr)
library(httr)

url = 'https://www.bls.gov/news.release/atus.t01.htm'

df = url %>%
  GET() %>%
  read_html() %>%
  html_table(header = F)

a = scan(url)
