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

## Retrieve only the coal combustion-related sources
coalSources <- filter(NEISCC, grepl("vehicle", NEISCC$SCC.Level.Two, ignore.case = TRUE))

## Create the set filtered by Baltimore, group by year, 
## and compute per group the total emission (sum)
totalSet <- coalSources %>% 
    filter(fips == "24510") %>% 
    group_by(year) %>% 
    summarise(totalSum = sum(Emissions))

## Open png_file
png(filename="plot5.png", width=600, height=480, units="px")

## Make the plot:
## - year/totalSum
## - make a line-graph
## - set the y-range to 0 - max(totalSet$totalSum)
g <- ggplot(totalSet, aes(x = year, y = totalSum)) + 
    geom_line() + 
    labs(title = expression("Total emission PM"[2.5]*" of motor vehicle sources in Baltimore"), x = "Year", y = "Emission (in ton)") +
    coord_cartesian(ylim = c(0, max(totalSet$totalSum)))
print(g)

## Close PNG-file
dev.off()
