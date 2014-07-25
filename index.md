---
title       : CityBike
subtitle    : a peek into the past
author      : H. Vautz
job         : BI Consultant, future data scientist
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## An shiny-App to take a peek into the past of CityBike (NY)


* using real data from [citibikenyc](http://www.citibikenyc.com)
* it's a very simple POC to test the flexibility and possibilities of shiny (especially leaflet)

--- 

## Some facts about the Data

* with the determining factor of shiny (it's pretty slow) only a very small part of the available<br /> data could be used ( 30,000 rows of ~900,000 rows for 05/2014 )
* the whole dataset of May has about 6,200 unique bikes
* in May all bikes together were rode for about 211,718 hours (8,822 days)
* the chosen data (first 30,000 rows) contain about 7,011 hours (292 days) and 4615 bikes

--- 

## More facts about the Data

* The top 5 starting stations, regarding trip duration (in seconds)





```r
library(plyr)
top <- ddply(dat,~start.station.name,summarise,sum=sum(tripduration),mean=mean(tripduration))
top <- top[order(top$sum, decreasing=T),]

top[1:5, ]
```

```
##                    start.station.name     sum   mean
## 60                 Broadway & W 60 St 9247300 1352.1
## 321             West St & Chambers St 8908053 1158.8
## 69             Central Park S & 6 Ave 8111882 2011.4
## 132          E 42 St & Vanderbilt Ave 7900347  810.5
## 173 Grand Army Plaza & Central Park S 7459531 1507.0
```

---

## Don't forget ...

... to try this app 

[CityBike - App](http://hvautz.shinyapps.io/CityBike/)    
*it may take a bit, shiny is not the fastest :(*


and if you want the code:

[Github - repo](https://github.com/hvautz/city_bike_app)

