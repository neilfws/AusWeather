library(digest, lib.loc = "/home/sau103/R/i686-pc-linux-gnu-library/2.13")
library(proto, lib.loc = "/home/sau103/R/i686-pc-linux-gnu-library/2.13")
library(plyr, lib.loc = "/home/sau103/R/i686-pc-linux-gnu-library/2.13")
library(bitops, lib.loc = "/home/sau103/R/i686-pc-linux-gnu-library/2.13")
library(RCurl, lib.loc = "/home/sau103/R/i686-pc-linux-gnu-library/2.13")
library(rjson, lib.loc = "/home/sau103/R/i686-pc-linux-gnu-library/2.13")
library(reshape, lib.loc = "/home/sau103/R/i686-pc-linux-gnu-library/2.13", warn.conflicts = F)
library(ggplot2, lib.loc = "/home/sau103/R/i686-pc-linux-gnu-library/2.13", warn.conflicts = F)

setContentType("image/png")
d <- fromJSON(getURL("http://localhost:28017/bom/records/"))
d <- ldply(d$rows, function(x) as.data.frame(x))
t <- tempfile()
#print(d)
png(t,type="cairo", width = 640, height = 480)
gg <- ggplot(d) + geom_point(aes(as.Date(date), max, color = factor(predicted))) + geom_point(aes(as.Date(date), min, color = factor(predicted))) +
                  xlab("Date") + ylab("Temperature")
print(gg)
dev.off()
sendBin(readBin(t,'raw',n=file.info(t)$size))
unlink(t)
DONE

