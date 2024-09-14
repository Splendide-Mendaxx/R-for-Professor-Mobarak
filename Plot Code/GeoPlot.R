# Load necessary libraries
library(sf)
library(ggplot2)
library(dplyr)

# Read in your spatial data
GeoJson_File <- "/Users/ariyanmishra/Desktop/Adventures on R/CPS/us-states.json"
my_sf <- read_sf(GeoJson_File)

my_sf <- my_sf %>% rename(Jurisdiction = name)

# Read in your data
data <- read.csv("Opioid Data.csv")
data <- data[, 1:2]
colnames(data) <- c("Jurisdiction", "Cost")
data$Cost <- as.numeric(gsub(",", "", data$Cost))



# Perform a left join to keep all states in the spatial data
merged_data <- left_join(my_sf, data, by = "Jurisdiction")

# Categorize Cost values into intervals
merged_data <- merged_data %>%
        mutate(Cost_category = cut(Cost, 
                                   breaks = c(0, 1200, 2600, 3300, 4200, 7300), 
                                   labels = c("$0-$1200", "$1200-$2600", "$2600-$3300", "$3300-$4200", "$4200-$7300"),
                                   right = FALSE))
ggplot(merged_data) +
        geom_sf(aes(fill = Cost_category), linewidth = 0.1, alpha = 0.9) +
        theme_void() +
        scale_fill_viridis_d(na.value = "lightgray", name = "Cost: ") +
        labs(
                title = "Per Capita Combined Costs of Opioid Use Disorder and Fatal Opioid Overdose — United States, 2017",
                fill = "Cost Interval",
                caption = "Data: Sourced from CDC"
        ) +
        theme(text = element_text(family = "Times New Roman"),
              legend.position = c(0.95, 0.3))