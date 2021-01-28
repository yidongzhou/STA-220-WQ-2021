library(tidyverse)
# The tidyverse is an opinionated collection of R packages designed for data science. All packages share an underlying design philosophy, grammar, and data structures.
# e.g., ggplot2 for nice plot, dplyr for data manipulation, and so on
# The tidyverse also includes many other packages with more specialised usage. They are not loaded automatically with library(tidyverse), so you’ll need to load each one with its own call to library()
# The one we are going to use is rvest (Easily Harvest (Scrape) Web Pages)
library(rvest)

# the zillow website for Sacramento
# You can definitely use ZillowR package, which serve as an R Inteface to Zillow Real Estate and Mortgage.
# However, here we want to use rvest package.

links <- sprintf("https://www.zillow.com/sacramento-ca/%d_p", 1:11)
# sprintf: A wrapper for the C function sprintf, that returns a character vector containing a formatted combination of text and variable values.
# equivalent to paste0("https://www.zillow.com/sacramento-ca/", 1:11, "_p")

# To build a data frame

# map: Apply a function or a formula to each element of a list or atomic vector
# .x represents one element in the first argument.
results <- map(links, ~ {
  # http://flukeout.github.io/
  # http://selectorgadget.com/
  # <body
  # class="photo-cards
  houses <- read_html(.x) %>%
    html_nodes(".photo-cards li article")
  z_id <- houses %>%
    html_attr("id")
  
  address <- houses %>%
    html_node(".list-card-addr") %>%
    html_text()
  
  price <- houses %>%
    html_node(".list-card-price") %>%
    html_text() %>%
    readr::parse_number()
  
  params <- houses %>%
    html_node(".list-card-info") %>%
    html_text()
  # number of bedrooms
  beds <- params %>%
    str_extract("\\d+(?=\\s*bds)") %>%
    as.numeric()
  # number of bathrooms
  baths <- params %>%
    str_extract("\\d+(?=\\s*ba)") %>%
    as.numeric()
  # total square footage
  house_a <- params %>%
    str_extract("[0-9,]+(?=\\s*sqft)") %>%
    str_replace(",", "") %>%
    as.numeric()
  
  tibble(price = price, beds= beds, baths=baths, house_area = house_a)
  
}
) %>%
  bind_rows(.id = 'page_no')
