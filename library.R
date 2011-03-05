library(rmemcache)
# Create a list of connections to all memcache searvers
m <- lapply(readLines('memcache_ip.txt'),function(x)  mcConnect(paste(x,':11211',sep='')))
eskape <- function(key) gsub(' ','|',key)

query_bigram <- function(key,counts=c('match','page','volume'),years=c(1890,2008)) {
	x <- unlist(lapply(m,function(x) mcGet(x,eskape(key))))
	if (is.null(x)) return(NULL)
	as.integer(strsplit(x,' ')[[1]])[seq(years[1]-1889,years[2]-1889)]
}

parse_to_ngram <- function(x,ngrams=c(1,2,3,4,5)){
	x <- strsplit(paste(x,collapse=' '),'[\n\t ]+',perl=TRUE)[[1]]
	x <- x[x!='']

	if (ngrams[1] == 1)
		x
	else if (ngrams[1] == 2){
		len <- length(x)
		lm1 <- len - 1
		paste(x[1:lm1],x[2:len],sep=' ')
	}
}

bigram_matches <- function(Text){
	x <- unlist(lapply(parse_to_ngram(Text,ngrams=2),query_bigram))
	dim(x) <- c(119,length(x)/119)
	x
}

# To sum over all matches use
# rowSums(bigram_matches())

