library(dplyr)
library(canvasXpress)

passwords <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-14/passwords.csv')

plot_data <- passwords %>% 
  filter(!is.na(category)) %>%
  group_by(category) %>% 
  summarise(crack_time = mean(offline_crack_sec, na.rm = T)) %>% 
  arrange(-crack_time)

data     <- t(plot_data %>% tibble::column_to_rownames("category"))
var_data <- data.frame(Plot = c("Time"), stringsAsFactors = F)
rownames(var_data) <- rownames(data)

canvasXpress(
    graphType               = "Bar",
    data                    = data,
    varAnnot                = var_data,
    colors                  = "lightblue",
    xAxis2Title             = "Time (sec)",
    showLegend              = FALSE,
    marginBottom            = 80,
    title                   = "Average time to crack a password by category",
    titleScaleFontFactor    = 0.7,
    citation                = "Source: Information is Beautiful, Viz: @g_inberg",
    layoutTopology          = "1x1",
    xAxisShow               = FALSE)

