plot2<-function(){
  
  inData <- read.csv("household_power_consumption.txt",sep=";",na.strings = "?",colClasses=c(rep('character',2),rep('numeric',7)))
  inData$Timestamp <- strptime(paste(inData$Date,inData$Time),
                             format="%d/%m/%Y %H:%M:%S")
  inData = subset(inData,as.Date(inData$Timestamp) >= "2007-02-01" 
                    & as.Date(inData$Timestamp) < "2007-02-03")
  
  png("plot2.png", width=480, height=480)
  
  plot(inData$Timestamp,inData$Global_active_power,type="l", xlab="",ylab="Global Active Power (kilowatts)")
  
  dev.off()
  
}
  