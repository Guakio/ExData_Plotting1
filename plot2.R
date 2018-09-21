#Scrip for plot2 in repo


plot2 <- function () {
        
        
# Collect data information and download files if doesn't exist in work directory
        
        filename <- "exdata_data_household_power_consumption.zip"
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        dir <- "exdata_data_household_power_consumption"
        
        if(!file.exists(filename)){
                download.file(url,filename, mode = "wb") 
        }
        
        if(!file.exists(dir)){
                unzip(filename, files = NULL, exdir=".")
        }
        
#read data (I found the values for nrows in notepad first to read only the data we need)
        
        head <- names(read.csv ("household_power_consumption.txt", sep = ";", nrow=1))
        dataset <- read.table ("household_power_consumption.txt", sep=";", skip=66636, nrow = 2881)
        names(dataset) <- head
        
# Convert date and time with lubridate and mutate with dplyr 
        
        if (!"lubridate" %in% installed.packages()) {
                install.packages("lubridate")
        }
        
        if (!"dplyr" %in% installed.packages()) {
                install.packages("dplyr")
        }
        
        library("lubridate")
        library("dplyr")
        
        dataset[dataset=="?"]<-NA 
        dataset<-mutate(dataset, datetime = dmy_hms(paste (dataset$Date, dataset$Time)))
        
#PLot 2
        
        plot(dataset$datetime, dataset$Global_active_power, xlab = "", ylab= "Global Active Power (Kilowatts)", type="l")
        dev.copy (png, filename = "plot2.png", width = 480, height = 480)
        dev.off()
        
}