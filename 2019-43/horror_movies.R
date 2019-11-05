# title: "Tidy Tuesday - Horror Movie Ratings"
# author: "Ger Inberg"
# date: "27 octobre 2019"

library(canvasXpress)
library(tidyverse)
library(lubridate)

movies <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-22/horror_movies.csv") %>%
  mutate(month(dmy(release_date), label=T))


# Horror movies per country
movies_per_country <- movies %>%
  group_by(release_country) %>%
  summarise(total = n()) %>%
  arrange(-total) %>%
  top_n(10)

y <- movies_per_country %>% 
  tibble::column_to_rownames("release_country") %>%
  t() %>% 
  as.data.frame()

canvasXpress(
  data             = y,
  graphOrientation ="horizontal",
  graphType        = "Bar",
  showLegend       = FALSE,
  title            = "Amount of horror movies per country")

