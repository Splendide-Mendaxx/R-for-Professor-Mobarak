#Load Necessary Libraries
library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggthemes)

# Load the data
data <- read_csv("Master_Data.csv")

# Convert Date column to Date type
data <- data %>%
        mutate(Date = as.Date(Date, format = "%Y-%m-%d"))

# Filter data to include only 2019 to 2022
data_filtered <- data %>%
        filter(year(Date) >= 2019 & year(Date) <= 2023)

# Extract January 2019 values for reference
jan_2019 <- data_filtered %>%
        filter(year(Date) == 2019 & month(Date) == 1)

jan_2019_eprawd <- jan_2019$EPRMWD
jan_2019_eprawod <- jan_2019$`EPRMW/OD`

# Calculate percent difference relative to January 2019
data_filtered <- data_filtered %>%
        mutate(
                eprawd_percent_diff = (EPRMWD - jan_2019_eprawd) / jan_2019_eprawd * 100,
                eprawod_percent_diff = (`EPRMW/OD` - jan_2019_eprawod) / jan_2019_eprawod * 100
        )

# Plot the data
ggplot(data_filtered, aes(x = Date)) +
        geom_line(aes(y = eprawd_percent_diff, color = "Men with Disabilities")) +
        geom_line(aes(y = eprawod_percent_diff, color = "Men without Disabilities")) +
        geom_point(aes(y = eprawd_percent_diff, color = "Men with Disabilities")) +
        geom_point(aes(y = eprawod_percent_diff, color = "Men without Disabilities")) +
        scale_x_date(
                date_breaks = "3 months", 
                date_labels = "%b %y", 
                limits = as.Date(c("2019-01-01", "2023-01-01"))
        ) +
        labs(
                title = "Percent Difference in Employment-to-Population Ratio by Disability Status, Men, Rel. to Jan. 2019",
                y = "% Difference",
                color = "Disability Status: "
        ) +
        geom_hline(yintercept = 0, linetype = 2) + theme_minimal() +
        theme(axis.text.x = element_text(angle = 30, hjust = 0.5, vjust = 0.5), 
              legend.position = "bottom", text = element_text(family = "Times New Roman"), 
              plot.title = element_text(hjust = 0.5), axis.title.x = element_blank(),
              legend.box.background=element_rect()) +
        scale_color_manual(
                values = c("Men with Disabilities" = "blue", "Men without Disabilities" = "red"),
                name = "Disability Status: "
        ) 
        
        
        
