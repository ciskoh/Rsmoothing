# Script to perform smoothing and interpolation on NDVI time series

library(raster)
library(rgdal)
library(signal)
library(timeSeries)
library(zoo)

# load tiff file with time series ndvi in R
a=brick(
  'C:/Users/jkm2/Dropbox/ongoing/BFH-Pastures/gis data/Analysis/fromGEE-Sentinel/monthlyAverageNDVI.tif')

# plotting time series RAW

I=cellStats(a, stat=mean)
a.raw.ts = ts(I, start=c(2013,4), end=c(2017,12), frequency=12)
plot(a.raw.ts, main= "NDVI raw time series")

# From website
fun2 <- function(x) {
  v=as.vector(x)
  z=substituteNA(v, type = 'mean')
  a.ts2 = ts(z, start=c(2013,4), end=c(2017,12), frequency=12)
  x=sgolayfilt(a.ts2, p=3, n=2, ts=1)
  }

a.filtered <- calc(a, fun2) # filtered is a new brick containing the smoothed time series. Compare the raw with the filtered tims series:


l=cellStats(a.filtered, stat=mean)
a.filt.ts = ts(l, start=c(2013,4), end=c(2017,12), frequency=12)
plot(a.raw.ts, col="red")
par(new=TRUE)
plot(a.filt.ts)
# 
# One may find out the perfect fitting parameters by looking at the whole area, playing with the parameters:
#   
#   l=cellStats(MODIS, stat='mean')
# MODIS.ts = ts(l, start=2005, end=c(2010,23), frequency=23)
# sg=sgolayfilt(MODIS.ts, p=3, n=9, ts=20)
# sg.ts = ts(sg, start=2005, end=c(2010,23), frequency=23)
# 
# plot(sg.ts)