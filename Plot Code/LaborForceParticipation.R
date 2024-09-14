#Load Necessary Libraries
library(tidyverse)
library(lubridate)
library(ggplot2)

# Load the data
data <- read_csv("LaborForceParticipation.csv")
colnames(data) <- c("RowNumber","Date", "LFP_D", "LFP_ND")

# Convert Date column to Date type
data <- data %>%
        mutate(Date = as.Date(Date, format = "%Y-%m-%d"))

# Filter data to include only 2009 to 2024
data_filtered <- data %>%
        filter(year(Date) >= 2009 & year(Date) <= 2024)

# Extract January 2009 values for reference
jan_2009 <- data_filtered %>%
        filter(year(Date) == 2009 & month(Date) == 1)

jan_2009_LFP_D <- jan_2009$LFP_D
jan_2009_LFP_ND <- jan_2009$LFP_ND

# Calculate percent difference relative to January 2009
data_filtered <- data_filtered %>%
        mutate(
                LFP_D_percent_diff = (LFP_D - jan_2009_LFP_D) / jan_2009_LFP_D * 100,
                LFP_ND_percent_diff = (LFP_ND - jan_2009_LFP_ND) / jan_2009_LFP_ND * 100
        )

# Plot the data
ggplot(data_filtered, aes(x = Date)) +
        geom_line(aes(y = LFP_D_percent_diff, color = "With Disability")) +
        geom_line(aes(y = LFP_ND_percent_diff, color = "Without Disability")) +
        geom_point(aes(y = LFP_D_percent_diff, color = "With Disability"), size = 0.5) +
        geom_point(aes(y = LFP_ND_percent_diff, color = "Without Disability"), size = 0.5) +
        scale_x_date(
                date_breaks = "3 months", 
                date_labels = "%b %y", 
                limits = as.Date(c("2009-01-01", "2024-01-01")),
                expand = c(0, 0) # Remove the extra space around the data
        ) +
        coord_cartesian(xlim = as.Date(c("2009-01-01", "2024-01-01"))) +
        labs(
                title = "Percent Difference in Labor Force Participation Rate, Rel. to Jan. 2009 by Disability Status",
                y = "% Difference",
                color = "Disability Status: "
        ) +
        geom_hline(yintercept = 0, linetype = 2) + 
        theme(axis.text.x = element_text(angle =90, hjust = 0.5, vjust = 0.5), 
              legend.position = "bottom", text = element_text(family = "Times New Roman"), 
              plot.title = element_text(hjust = 0.5), axis.title.x = element_blank(),
              legend.box.background=element_rect()) +
        scale_color_manual(
                values = c("With Disability" = "blue", "Without Disability" = "red"),
                name = "Disability Status: "
        )



