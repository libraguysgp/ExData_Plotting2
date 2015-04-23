#==============================================================================
# R script (plot5.R):
# Notes:
# 1. The script only tested on windows 8.1 with R Studio only.
# 2. This script will check and auto download the required dataset if not exist.
# 3. The dataset and created PNG were stored in %userprofile%/Documents/ExData_Plotting2
#==============================================================================

#------------------------------------------------------------------------------
# Define course project working directory
#------------------------------------------------------------------------------
setwd("~")
working.folder <- file.path(getwd(), "ExData_Plotting2")
dir.create((working.folder), showWarnings = FALSE)
setwd (working.folder)
data.file <- paste(working.folder, "summarySCC_PM25.rds", sep = "/")

#------------------------------------------------------------------------------
# Store Web data source as data.url
#------------------------------------------------------------------------------
data.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

#==============================================================================
# Data set download function:
# 1. Downloads the Electric Power Consumption dataset if not exist locally
#==============================================================================
if (!file.exists(data.file)) {
  cat('Downloading the data set; this may take a few moments...')
  tmp <- tempfile()    
  head(tmp)
  download.file(data.url, tmp, cacheOK = FALSE)
  unzip(tmp)
  cat("Dataset downloaded and extracted to", getwd())
  unlink(tmp)
}else {
  cat("Dataset already exist...")
}

#------------------------------------------------------------------------------
# Loading downloaded datasets from local machine
#------------------------------------------------------------------------------
cat ('These 2 lines will likely take a few seconds. Be patient!')
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#------------------------------------------------------------------------------
# Preparing data for the plot.
#------------------------------------------------------------------------------
# Get Baltimore emissions from motor vehicle sources
Baltimore.emissions <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
Baltimore.emissions.aggr <- aggregate(Emissions ~ year, data=Baltimore.emissions, FUN=sum)
#------------------------------------------------------------------------------
# Creating Plot PNG Image File
#------------------------------------------------------------------------------
message('Creating png image file....')
png("plot5.png",width=480,height=480,units="px",bg="transparent")

ggplot(Baltimore.emissions.aggr, aes(x=factor(year), y=Emissions)) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression("Total PM"[2.5]*" Emissions (in tons)")) +
  ggtitle("Emissions from motor vehicle sources in Baltimore City")

message("plot5.png has been saved in", getwd())

dev.off()
