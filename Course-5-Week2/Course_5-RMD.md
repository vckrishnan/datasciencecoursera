---
output: 
  html_document:
    keep_md: TRUE
---

# Reproducible Research - Week #2 Assignment
####Author: Chennakrishnan VIjayarangan
####Date: 04-May-2018

------


Download the source data and place it in the working directory  
Read the CSV file, and load the data into a Dataframe    

```r
  inputDF <- read.csv("activity.csv")
```

###Q1: What is mean total number of steps taken per day?  
  
#####Q1.1 - Calculate the total number of steps taken per day  
Using Aggregate() function Calculated Total number of steps taken per day

```r
  totalStepsPerDay <- aggregate(steps ~ date, inputDF, sum)
```
  
#####Q1.2 - Make a histogram of the total number of steps taken each day  
Load the library ggplot2

```r
require("ggplot2")
```

```
## Loading required package: ggplot2
```
Drawn the histogram using ggplot by passing the dataframe returned by the aggregate funtion

```r
  ggplot(totalStepsPerDay, aes(x=steps)) + 
      geom_histogram(color="darkgray", fill="white") + 
      ggtitle("Total mean total number of Steps Taken per Day") +
      theme(legend.position="none")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](Course_5-RMD_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

#####Q1.3 - Calculate and report the mean and median of total number of steps taken per day
Calculted and reported mean of total number of steps taken per day using mean()

```r
  mean(totalStepsPerDay$steps)
```

```
## [1] 10766.19
```

Calculated and reported Median of total number of steps taken per day using median()

```r
  median(totalStepsPerDay$steps)
```

```
## [1] 10765
```

###Q2: What is the average daily activity pattern?

#####Q2.1 Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

Using aggregate() function Calculated average number of steps taken per on time interval

```r
avg_steps_OnInterval <- aggregate(steps ~ interval, inputDF, mean)  
```

Drawn the time series graph using ggplot by passing the dataframe returned by the aggregate funtion


```r
ggplot(avg_steps_OnInterval, aes(x= interval, y=steps)) +
    geom_line()+
    theme(legend.position="none")
```

![](Course_5-RMD_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

#####Q2.2 Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
  avg_steps_OnInterval[which.max(avg_steps_OnInterval$steps),1]
```

```
## [1] 835
```

###Q3: Imputing missing values

#####Q3.1 Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

Summary() returns the total number of missing values as well

```r
  summary(inputDF)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##  NA's   :2304     (Other)   :15840
```
  
Strategy for Imputing missing Values

```r
imput_DF <- inputDF 
missingValues <- is.na(inputDF$steps)
```
Using tapply() calculated the mean on steps taken per day

```r
mstep_OnDays <- tapply(inputDF$steps, inputDF$interval, mean, na.rm=TRUE)
```

Imputting the missed values and calculating the mean

```r
imput_DF$steps[missingValues] <- mstep_OnDays[as.character(inputDF$interval[missingValues])]
totalStepsPerDay <- aggregate(steps ~ date, imput_DF, sum)
```

Using ggplot2 drawn the histogram

```r
  ggplot(totalStepsPerDay, aes(x=steps)) + 
    geom_histogram(color="darkgray", fill="white") + 
    ggtitle("Total mean total number of Steps Taken per Day")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](Course_5-RMD_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

Calculted and reported mean of total number of steps taken per day using mean()

```r
mean(totalStepsPerDay$steps)
```

```
## [1] 10766.19
```

Calculated and reported Median of total number of steps taken per day using median()

```r
median(totalStepsPerDay$steps)
```

```
## [1] 10766.19
```

###Q4: Are there differences in activity patterns between weekdays and weekends?
  
#####Q4.1 Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
  
Using weekdays() function populated a newly created vector weekdays in the imputted DataFrame

```r
imput_DF$dayofweek <- weekdays(as.Date(imput_DF$date))
```
  
Using ifelse() identified and populated a given date as weekday or weekend, and then drawn the graph using ggplot2

```r
imput_DF$weekend <- ifelse(imput_DF$dayofweek == "Saturday" |imput_DF$dayofweek == "Sunday", "Weekend", "Weekday")
Q4_ag_data <- aggregate(steps ~ interval + weekend, imput_DF, mean)
ggplot(Q4_ag_data, aes(x= interval, y=steps, color="weekend"))+
    geom_line()+
    facet_grid(.~ weekend) +
  theme(legend.position="none")
```

![](Course_5-RMD_files/figure-html/unnamed-chunk-18-1.png)<!-- -->
