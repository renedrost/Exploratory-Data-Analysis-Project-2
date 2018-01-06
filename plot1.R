library(dplyr)

## Get data files.
if (!file.exists("NEI.zip")) {
    download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI.zip")
    unzip("NEI.zip")
}

## Read datafiles (if they aren't already in memory)
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

## Compute total emission per year
totalSet <- NEI %>% group_by(year) %>% summarise(totalSum = sum(Emissions))

## Open PNG-file
png(filename="plot1.png", width=480, height=480, units="px")

## Plot year versus total emission
with(totalSet, plot(year, 
                    totalSum, 
                    type="l", 
                    ylab = "Emission (in ton)", 
                    xlab="Year", 
                    main=expression("Total emission PM"[2.5]*" in the US")
                    )
    )

## Close PNG-file
dev.off()