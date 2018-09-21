#Scrip for plot4 in repo


plot4 <- function () {
        
        
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
        
        #PLot 4
        
        par(mfrow=c(2,2), mar=c(4.5, 4.5, 3,1))
        plot(dataset$datetime, dataset$Global_active_power, xlab = "", ylab= "Global Active Power (Kilowatts)", type="l")
        
        plot(dataset$datetime, dataset$Voltage, xlab = "datetime", ylab= "Voltage", type="l")
        
        plot (dataset$datetime, dataset$Sub_metering_1, type = "n", xlab="", ylab="Energy sub metering")
                points(dataset$datetime, dataset$Sub_metering_1, type="l", col="black")
                points(dataset$datetime, dataset$Sub_metering_2, type="l", col="red")
                points(dataset$datetime, dataset$Sub_metering_3, type="l", col="blue")        
                legend ("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), bty= "n", 
                        cex=0.60, seg.len=1,x.intersp=0.1, y.intersp=0.30, lty = 1)
        
        plot(dataset$datetime, dataset$Global_reactive_power, xlab = "datetime", ylab= "Voltage", type="l")
                
        
        dev.copy (png, filename = "plot4.png", width = 480, height = 480)
        dev.off()
        
}