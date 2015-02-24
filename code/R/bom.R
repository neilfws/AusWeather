library(plyr)
library(RCurl)
library(rjson)
library(reshape)
library(ggplot2)

setwd("~/Dropbox/projects/bom")

d <- fromJSON(file = "data/bom.json")
d <- ldply(d$rows, function(x) as.data.frame(x))

pdf(file = "output/bom.pdf", width = 9, height = 7)
gg <- ggplot(d) + geom_point(aes(as.Date(date), max, color = factor(predicted))) + 
  geom_point(aes(as.Date(date), min, color = factor(predicted))) +
                  xlab("Date") + ylab("Temperature") + theme_bw()
print(gg)
dev.off()
