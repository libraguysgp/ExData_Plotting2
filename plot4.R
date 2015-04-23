#==============================================================================
# R script (plot4.R):
# Notes:
# 1. The script only tested on windows 8.1 with R Studio only.
# 2. This script will check and auto download the required dataset if not exist.
# 3. The dataset and created PNG were stored in %userprofile%/Documents/04_Exploratory_Data_Analysis
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
# Coal combustion related sources
SCC.coal = SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),]

# Merge two data sets
merge <- merge(x=NEI, y=SCC.coal, by='SCC')
merge.sum <- aggregate(merge[, 'Emissions'], by=list(merge$year), sum)
colnames(merge.sum) <- c('Year', 'Emissions')
#------------------------------------------------------------------------------
# Creating Plot PNG Image File
#------------------------------------------------------------------------------
message('Creating png image file....')
png("plot4.png",width=480,height=480,units="px",bg="transparent")

ggplot(data=merge.sum, aes(x=Year, y=Emissions/1000)) + 
  geom_line(aes(group=1, col=Emissions)) + geom_point(aes(size=2, col=Emissions)) + 
  ggtitle(expression('Total Emissions of PM'[2.5])) + 
  ylab(expression("Total" ~ PM[2.5] ~ "Emissions (in thousands of tons)")) + 
  geom_text(aes(label=round(Emissions/1000,digits=2), size=2, hjust=1.5, vjust=1.5)) + 
  theme(legend.position='none') + scale_colour_gradient(low='black', high='red')

message("plot4.png has been saved in", getwd())

dev.off()
