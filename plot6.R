#==============================================================================
# R script (plot6.R):
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
# Gather the subset of the NEI data which corresponds to vehicles
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]

# Subset the vehicles NEI data by each city's fip and add city name.
vehiclesBaltimoreNEI <- vehiclesNEI[vehiclesNEI$fips=="24510",]
vehiclesBaltimoreNEI$city <- "Baltimore City"

vehiclesLANEI <- vehiclesNEI[vehiclesNEI$fips=="06037",]
vehiclesLANEI$city <- "Los Angeles County"

# Combine the two subsets with city name into one data frame
bothNEI <- rbind(vehiclesBaltimoreNEI,vehiclesLANEI)
#------------------------------------------------------------------------------
# Creating Plot PNG Image File
#------------------------------------------------------------------------------
message('Creating png image file....')
png("plot6.png",width=480,height=480,units="px",bg="transparent")

ggp <- ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (in kilo tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

print(ggp)
message("plot6.png has been saved in", getwd())

dev.off()
