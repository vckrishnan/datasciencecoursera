plot4<-function(){
  
  inData <- read.csv("household_power_consumption.txt",sep=";",na.strings = "?",colClasses=c(rep('character',2),rep('numeric',7)))
  inData$Timestamp <- strptime(paste(inData$Date,inData$Time),
                             format="%d/%m/%Y %H:%M:%S")
  inData = subset(inData,as.Date(inData$Timestamp) >= "2007-02-01" 
                    & as.Date(inData$Timestamp) < "2007-02-03")
  
  png("plot4.png", width=480, height=480)

  par(mfrow=c(2,2))
  
  #Plot 1
  plot(inData$Timestamp,inData$Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)")
  
  #Plot 2
  plot(inData$Timestamp,inData$Voltage,type="l",xlab="datetime",ylab="Voltage")
  
  #Plot 3
  plot(inData$Timestamp,inData$Sub_metering_1,type="l",xlab="",ylab="Energy sub metering")
  lines(inData$Timestamp,inData$Sub_metering_2,type="l",col="red")
  lines(inData$Timestamp,inData$Sub_metering_3,type="l",col="blue")
  legend(x="topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1),lwd=2,col=c("black","red","blue"),bty="n")
  
  #plot 4
  plot(inData$Timestamp,inData$Global_reactive_power,type="l", xlab="datetime",ylab="Global_reactive_power")
  dev.off()
  
}
  
