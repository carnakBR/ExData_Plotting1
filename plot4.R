#This code uses the Electric power consumption dataset from the UC Irvine Machine Learning Repository, and assumes the zip file containing the data was downloaded to a folder inside the project folder named "data"

library(dplyr)

#read the zip file into R, defining the column classes by reading the first 50 rows before reading the whole file to make it faster
initial <- read.csv2(unz("./data/exdata_data_household_power_consumption.zip", "household_power_consumption.txt"), dec=".", na.strings = "?", nrows=50)
classes <- sapply(initial, class)
powerdata <- read.csv2(unz("./data/exdata_data_household_power_consumption.zip", "household_power_consumption.txt"), dec=".", na.strings = "?", colClasses=classes)

#create a new column datetime joining the Date and Time values as characters and then convert this new column to a POSIXlt class that represents date and time in R
powerdata$datetime <- paste(powerdata$Date, powerdata$Time, sep=" ")
powerdata <- mutate(powerdata, datetime = strptime(datetime, format="%d/%m/%Y %H:%M:%S"))

#subset the datapoints for the dates 2007-02-01 and 2007-02-02.
startdate <- as.POSIXlt("2007-02-01 00:00:00", format="%Y-%m-%d %H:%M:%S")
enddate <- as.POSIXlt("2007-02-03 00:00:00", format="%Y-%m-%d %H:%M:%S")
targetdata <- subset(powerdata, datetime>=startdate & datetime<enddate)

#make the plot and save it into the png file
png(filename="plot4.png")
par(mfrow = c(2, 2))
#Graph 1
with(targetdata, plot(datetime, Global_active_power, type="l", ylab="Global Active Power", xlab=""))

#Graph 2
with(targetdata, plot(datetime, Voltage, type="l", ylab="Voltage"))

#Graph 3
plot(targetdata$datetime, targetdata$Sub_metering_1, xlab="", ylab="Energy sub metering", type="n")
points(targetdata$datetime, targetdata$Sub_metering_1, col="black", type="l")
points(targetdata$datetime, targetdata$Sub_metering_2, col="red", type="l")
points(targetdata$datetime, targetdata$Sub_metering_3, col="blue", type="l")
legend("topright", lty = c(1,1,1), col = c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n")

#Graph 4
with(targetdata, plot(datetime, Global_reactive_power, type="l"))

dev.off()