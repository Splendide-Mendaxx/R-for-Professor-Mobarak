library(leaflet)
library(sf)
library(dplyr)
library(viridis)
GeoJson_File <- "/Users/ariyanmishra/Desktop/Adventures on R/CPS/us-states.json"
my_sf <- read_sf(GeoJson_File)
my_sf <- my_sf %>% rename(Jurisdiction = name)

data <- read.csv("Opioid Data.csv")
data <- data[, 1:2]
colnames(data) <- c("Jurisdiction", "Cost")
data$Cost <- as.numeric(gsub(",", "", data$Cost))

merged_data <- left_join(my_sf, data, by = "Jurisdiction")

merged_data <- merged_data %>%
        mutate(Cost_category = cut(Cost, 
                                   breaks = c(0, 1200, 2600, 3300, 4200, 7300), 
                                   labels = c("$0-$1204", "$1,204-$2,603", "$2,604-$3,337", "$3,338-$4,271", "$4,272-$7,247"),
                                   right = FALSE))
# Define color palette
palette <- colorFactor(
        palette = viridis::viridis(length(levels(merged_data$Cost_category))),
        domain = merged_data$Cost_category
)

# Create leaflet map
leaflet(data = merged_data) %>%
        addTiles() %>%
        addPolygons(
                fillColor = ~palette(Cost_category),
                weight = 1,
                opacity = 1,
                color = "white",
                dashArray = "3",
                fillOpacity = 0.7,
                highlightOptions = highlightOptions(
                        weight = 2,
                        color = "#666",
                        dashArray = "",
                        fillOpacity = 0.7,
                        bringToFront = TRUE
                ),
                label = ~paste0(Jurisdiction, ": ", Cost),
                labelOptions = labelOptions(
                        style = list("font-family" = "Times New Roman", "font-weight" = "normal", padding = "3px 8px"),
                        textsize = "15px",
                        direction = "auto"
                )
        ) %>%
        addLegend(
                pal = palette,
                values = ~Cost_category,
                opacity = 0.7,
                title = "<span style='font-family: Times New Roman;'>Cost Interval: </span>",
                position = "bottomright"
        ) %>%
        addControl(
                html = "<div style='font-family: Times New Roman;'><b>Per Capita Combined Costs of Opioid Use Disorder and Fatal Opioid Overdose — United States, 2017</b><br>Data: CDC - Created by Ariyan Mishra</div>",
                position = "topright"
        )
