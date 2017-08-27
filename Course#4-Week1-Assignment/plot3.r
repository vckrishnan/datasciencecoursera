plot3<-function(){
  
  inData <- read.csv("household_power_consumption.txt",sep=";",na.strings = "?",colClasses=c(rep('character',2),rep('numeric',7)))
  inData$Timestamp <- strptime(paste(inData$Date,inData$Time),
                             format="%d/%m/%Y %H:%M:%S")
  inData = subset(inData,as.Date(inData$Timestamp) >= "2007-02-01" 
                    & as.Date(inData$Timestamp) < "2007-02-03")
  
  png("plot3.png", width=480, height=480)
  
  plot(inData$Timestamp,inData$Sub_metering_1,type="l",xlab="",ylab="Energy sub metering")
  lines(inData$Timestamp,inData$Sub_metering_2,type="l",col="red")
  lines(inData$Timestamp,inData$Sub_metering_3,type="l",col="blue")
  legend(x="topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1),lwd=2,col=c("black","red","blue"))
  dev.off()
  
}
  
