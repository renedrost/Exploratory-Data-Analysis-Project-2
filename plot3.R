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

## Compute total emission per year for Baltimore (fips = 24510) per type
totalSet <- NEI %>% 
            filter(fips == "24510") %>% 
            group_by(year, type) %>% 
            summarise(totalSum = sum(Emissions))

## Open PNG-file
png(filename="plot3.png", width=600, height=480, units="px")

## Make the plot:
## - year/totalSum
## - group by type
## - colour by type
## - make line-graphs
g <- ggplot(totalSet, aes(x = year, y = totalSum, group=type, col=type)) + 
    geom_line() + 
    labs(title = expression("Total emission PM"[2.5]*" in Baltimore per type"), x = "Year", y = "Emission (in ton)")
print(g)

## Close PNG-file
dev.off()
