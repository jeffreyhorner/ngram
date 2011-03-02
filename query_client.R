#!/usr/bin/Rscript
library(rmemcache)


eskape <- function(k) sub(' ','|',k)
mcon <- mcConnect(servers='localhost:11211')
