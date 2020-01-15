library(dplyr)
library(canvasXpress)
library(htmlwidgets)

passwords <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-14/passwords.csv')

worst_passwords_per_category <- do.call(rbind, 
                                        lapply(unique(passwords$category), FUN = function(x) {
                                          passwords %>% 
                                            filter(category == x) %>% 
                                            arrange(offline_crack_sec) %>% 
                                            select(category, password) %>% 
                                            head(3) })) %>% 
  group_by(category) %>% 
  summarise(worst_passwords = paste(password, collapse = ", "))

plot_data <- passwords %>% 
  filter(!is.na(category)) %>%
  group_by(category) %>% 
  summarise(crack_time = mean(offline_crack_sec, na.rm = T)) %>% 
  left_join(worst_passwords_per_category) %>%
  arrange(-crack_time)

data     <- t(plot_data %>% select(category, crack_time) %>% tibble::column_to_rownames("category"))
smp_data <- plot_data %>% select(category, worst_passwords) %>% tibble::column_to_rownames("category")

custom_events <-  JS("{ 'mousemove' : function(o, e, t) {
                    if (o.objectType == null) {
                        t.showInfoSpan(e, '<b>' + o.y.smps[0] + '</b><br/>' +
                        '<b>Time:</b> ' + o.y.data[0] + '<br/>' +
                        '<b>Worst passwords:</b> ' + o.x.worst_passwords);
                    } else {
                        t.showInfoSpan(e, o.display);
                    }; }}")

canvasXpress(
    graphType               = "Bar",
    data                    = data,
    smpAnnot                = smp_data,
    colors                  = "lightblue",
    xAxis2Title             = "Time (sec)",
    showLegend              = FALSE,
    marginBottom            = 80,
    title                   = "Average time to crack a password by category",
    titleScaleFontFactor    = 0.7,
    citation                = "Source: Information is Beautiful, Viz: @g_inberg",
    xAxisShow               = FALSE,
    events                  = custom_events)


