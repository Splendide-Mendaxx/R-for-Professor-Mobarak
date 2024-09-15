library(sf)
library(dplyr)
library(ggplot2)
library(leaflet)


bangladesh_shape <- st_read("/Users/ariyanmishra/Desktop/Adventures on R/R for Professor Mobarak/Data/Bangladesh Maps/bgd_admbnda_adm3_bbs_20201113.shp")
socioeconomic_data <- read.csv("/Users/ariyanmishra/Desktop/Adventures on R/R for Professor Mobarak/Data/Bangladesh.csv")

#Rename Columns
bangladesh_shape <- bangladesh_shape %>% rename(Upazila.Name = ADM3_EN)

# Clean and Standardize Characters
bangladesh_shape$Upazila.Name <- trimws(tolower(bangladesh_shape$Upazila.Name))
socioeconomic_data$Upazila.Name <- trimws(tolower(as.character(socioeconomic_data$Upazila.Name)))

# Merge Data
upazila_data <- merge(bangladesh_shape, socioeconomic_data, by = "Upazila.Name") 

#Recapitalize
upazila_data$Upazila.Name <- tools::toTitleCase(upazila_data$Upazila.Name)


# Create categorized popup text 
upazila_data$popup_text <- paste0(
        
        # Upazila Name
        '<strong>Upazila: </strong>', upazila_data$Upazila.Name, '<br><br>',
        
        # Basic Information
        '<strong>Basic Information</strong><br>',
        'Total Population: ', format(upazila_data$Total.Population..N., big.mark = ","), '<br>',
        'Share of Rural Population: ', upazila_data$Rural.Population...., '%<br>',
        'Working Population: ', format(upazila_data$Working.age.population..N., big.mark = ","), '<br>',
        'Total Households: ', format(upazila_data$Number.of.Households..N., big.mark = ","), '<br><br>',
        
        # Poverty
        '<strong>Poverty</strong><br>',
        'Poverty Headcount Ratio: ', upazila_data$Poverty.headcount.ratio...., '%<br>',
        'Extreme Poverty Headcount Ratio: ', upazila_data$Extreme.poverty.headcount.ratio...., '%<br><br>',
        
        # Primary Employment
        '<strong>Primary Employment</strong><br>',
        'Agriculture: ', upazila_data$Primary.employment..Agriculture...., '%<br>',
        'Industry: ', upazila_data$Primary.employment..Industry...., '%<br>',
        'Services: ', upazila_data$Primary.employment..Services...., '%<br><br>',
        
        # Energy and Sanitation
        '<strong>Energy and Sanitation</strong><br>',
        'Households with Electricity: ', upazila_data$Households.with.Electricity...., '%<br>',
        'Households with Flush Toilet: ', upazila_data$Households.with.flush.toilet...., '%<br>',
        'Households with Non-Flush, Latrine: ', upazila_data$Households.with.non.flush..latrine...., '%<br>',
        'Households with Tap Water: ', upazila_data$Households.with.tap.water...., '%<br>',
        'Households with Tubewell Water: ', upazila_data$Households.with.tubewell.water...., '%<br>',
        'Households without Toilet, Open Defecation: ', upazila_data$Households.without.toilet..open.defecation...., '%<br><br>',
        
        # Literacy and Educational Attainment
        '<strong>Literacy and Educational Attainment</strong><br>',
        'Literate Population (18+): ', upazila_data$Literate.population..18.years.and.older....., '%<br>',
        'Educational Attainment: Less than Primary Completed (18+): ', upazila_data$Educational.attainment..Less.than.primary.completed..18.years.and.older....., '%<br>',
        'Educational Attainment: Primary Completed (18+): ', upazila_data$Educational.attainment..Primary.completed..18.years.and.older....., '%<br>',
        'Educational Attainment: Secondary Completed (18+): ', upazila_data$Educational.attainment..Secondary.completed..18.years.and.older...., '%<br>',
        'Educational Attainment: University Completed (18+): ', upazila_data$Educational.attainment..University.completed..18.years.and.older....., '%<br><br>',
        
        # School Attendance
        '<strong>School Attendance</strong><br>',
        'Attendance among 6-18 Years Old: ', upazila_data$School.attendance.among.6.18.years.old...., '%<br>',
        'Attendance among 6-10 Years Old: ', upazila_data$School.attendance.among.6.10.years.old...., '%<br>',
        'Attendance among 11-13 Years Old: ', upazila_data$School.attendance.among.11.13.years.old...., '%<br>',
        'Attendance among 14-15 Years Old: ', upazila_data$School.attendance.among.14.15.years.old...., '%<br>',
        'Attendance among 16-18 Years Old: ', upazila_data$School.attendance.among.16.18.years.old...., '%<br><br>',
        
        # Nutrition
        '<strong>Nutrition (Children Below 5)</strong><br>',
        'Underweight Children: ', upazila_data$Percentage.of.underweight.children...., '%<br>',
        'Severely Underweight Children: ', upazila_data$Percentage.of.severely.underweight.children...., '%<br>',
        'Stunted Children: ', upazila_data$Percentage.of.stunted.children...., '%<br>',
        'Severely Stunted Children: ', upazila_data$Percentage.of.severely.stunted.children...., '%<br>',
        
        '</div>'
)

# Create the Leaflet map
leaflet(data = upazila_data) %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        addPolygons(
                fillColor = ~colorBin("YlOrRd", domain = upazila_data$Poverty.headcount.ratio....)(Poverty.headcount.ratio....),  
                weight = 1,
                opacity = 1,
                color = 'white',
                dashArray = '3',
                fillOpacity = 0.7,
                highlightOptions = highlightOptions(
                        weight = 2,
                        color = "#666",
                        dashArray = "",
                        fillOpacity = 0.7,
                        bringToFront = TRUE
                ),
                popup = ~popup_text 
        ) %>%
        addLegend(
                pal = colorBin("YlOrRd", domain = upazila_data$Poverty.headcount.ratio....),
                values = ~Poverty.headcount.ratio....,
                opacity = 0.7,
                title = htmltools::HTML("<div style='font-family: Times New Roman;'>Poverty Headcount Ratio (%)</div>"),
                position = "bottomright"
        )%>%
        addControl(
                html = "<div style='font-family: Times New Roman; font-size: px; font-weight: bold;'>Poverty Indicators in Bangladesh - An Interactive Map</div>",
                position = "topright"
        ) %>%
        addControl(
                html = "<div style='font-family: Times New Roman; font-size: 14px;'>Data Source: World Bank, 2010-2012, Created by Ariyan Mishra</div>",
                position = "bottomleft"
        )