#!/usr/bin/Rscript
library(rmemcache)

hostip <- commandArgs(trailingOnly=TRUE)[1]
key <- commandArgs(trailingOnly=TRUE)[2]

eskape <- function(k) sub(' ','|',k)
mcon <- mcConnect(servers=paste(hostip,':11211',sep=''))
cat(mcGet(mcon,eskape(key)),'\n',sep='')
