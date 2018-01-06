library(dplyr)

## Get data files.
if (!file.exists("NEI.zip")) {
    download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI.zip")
    unzip("NEI.zip")
}

## Read datafiles (if they aren't already in memory)
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

## Compute total emission per year for Baltimore (fips = 24510)
totalSet <- NEI %>% filter(fips == "24510") %>% group_by(year) %>% summarise(totalSum = sum(Emissions))

## Open PNG-file
png(filename="plot2.png", width=480, height=480, units="px")

## Plot year versus total emission
with(totalSet, plot(year, 
                    totalSum, 
                    type = "l", 
                    ylab = "Emission (in ton)", 
                    xlab = "Year", 
                    main = expression("Total emission PM"[2.5]*" in Baltimore")
                    )
    )

## Close PNG-file
dev.off()