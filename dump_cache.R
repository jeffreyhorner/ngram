#!/usr/bin/Rscript
library(rmemcache)

mcon <- mcConnect(servers='localhost:11211')
con <- file('stdin',open='r')

l <- readLines(con,n=1,warn=FALSE)
while(length(l)){

	x <- strsplit(l,'\t')[[1]]

	key <- sub(' ','|',x[1])

	value <- mcGet(mcon=mcon,key=key)
	if (!is.null(value)){
		cat(x[1],'\t',value,'\n',sep='',file=stdout())
	}

	l <- readLines(con,n=1,warn=FALSE)
}
close(con)
