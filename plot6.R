library(dplyr)
library(ggplot2)

## Get data files.
if (!file.exists("NEI.zip")) {
    download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI.zip")
    unzip("NEI.zip")
}

## Read datafiles (if they aren't already in memory)
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

## Merge SCC-data with emissions
NEISCC <- inner_join(NEI, SCC, by = "SCC")

## Retrieve only the vehicle-related sources
vehicleData <- filter(NEISCC, grepl("vehicle", NEISCC$SCC.Level.Two, ignore.case = TRUE))

## Create the set filtered by Baltimore and LA County, group by year and fips, 
## and compute per group the total emission (sum)
totalSet <- vehicleData %>% 
    filter(fips %in% c("24510", "06037")) %>% 
    group_by(year, fips) %>% 
    summarise(totalSum = sum(Emissions))

## Add City-column
totalSet$City = c("")
## Fill City-column with appropriate values.
totalSet$City[totalSet$fips == "24510"] <- "Baltimore City"
totalSet$City[totalSet$fips == "06037"] <- "Los Angeles County"

## Start png-file
png(filename="plot6.png", width=600, height=480, units="px")

## Make the plot:
## - year/totalSum
## - make two plots, with own scale (so, the comparison can be made better)
## - group by City
## - add lineair model
## - remove facet-labels
g <- ggplot(totalSet, aes(x = year, y = totalSum, group=City, col=City)) + 
    facet_grid(fips ~ ., scales = "free") + 
    geom_line() + 
    geom_smooth(method = lm) + 
    labs(title = expression("Total emission PM"[2.5]*" of motor vehicle sources in Baltimore and LA County"), x = "Year", y = "Emission (in ton)") +
    theme(strip.text.y = element_blank())
print(g)

## Close PNG-file
dev.off()
