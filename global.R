# global.R
library(shiny)
library(rCharts)
library(RColorBrewer)

dat <- read.csv(file            = "./data/2014_05_trip_data.csv"
   , sep             = ","
   , header          = T
   , stringsAsFactor = F
   , na.strings = "\\N"
#   , nrows = 300001 # takes 2-3 min to load (local)
   , nrows = 100001
)

dat <- dat[, c(2:12)]

# set starttime and stoptime of type posixct
dat$starttime <- as.POSIXct(dat$starttime, format = "%Y-%m-%d %H:%M:%S", tz = "EST")
dat$stoptime <- as.POSIXct(dat$stoptime, format = "%Y-%m-%d %H:%M:%S", tz = "EST")
#dat$usertype <- as.factor(dat$usertype)
#dat$birth.year <- as.factor(dat$birth.year)
#dat$gender <- as.factor(dat$gender)

# get quantiles 
quant <- quantile(dat$starttime, names=F)
# set color palette
col <- brewer.pal(4, 'RdYlGn')

# set color by quantile information
dat$col[dat$starttime < quant[2]] = col[1] # first quantile
dat$col[dat$starttime >= quant[2] & dat$starttime < quant[3]] = col[2] # second
dat$col[dat$starttime >= quant[3] & dat$starttime < quant[4]] = col[3] # third
dat$col[dat$starttime >= quant[4]] = col[4] # fourth

