library(rmemcache)

# Change these to files that contain IP addresses, one per line
MEMCACHE_IPS<-'/home/hornerj/memcache_ip.txt'
MEMCACHE_IPS_1GRAM<-'/home/hornerj/memcache_ip_1gram.txt'
ips <- readLines(MEMCACHE_IPS)
ips <- c(ips,readLines(MEMCACHE_IPS_1GRAM))

# Create a list of connections to all memcache servers
m <- lapply(ips,function(x)  mcConnect(paste(x,':11211',sep='')))
eskape <- function(key) gsub(' ','|',key)

query_ngram <- function(key,counts=c('match','page','volume'),years=c(1890,2008),na.rm=FALSE) {
	x <- unlist(lapply(m,function(x) mcGet(x,eskape(key))))
	if (is.null(x)){
		if (na.rm) return(NULL)
		else return(rep(NA,years[2]-years[1]+1))
	}
	as.integer(strsplit(x,' ')[[1]])[seq(years[1]-1889,years[2]-1889)]
}

parse_to_ngram <- function(x,ngrams=c(1,2,3,4,5)){
	x <- strsplit(paste(x,collapse=' '),'[\n\t ]+',perl=TRUE)[[1]]
	x <- x[x!='']

	if (ngrams[1] == 2){
		len <- length(x)
		lm1 <- len - 1
		return(paste(x[1:lm1],x[2:len],sep=' '))
	}

	# Default case ngrams[1]==1
	x
}

ngram_matches <- function(Text,na.rm=FALSE){
	x <- unlist(lapply(Text,query_ngram,na.rm=na.rm))
	dim(x) <- c(119,length(x)/119)

	if (!na.rm) attr(x,'ngrams') <- Text
	x
}

bigram_matches <- function(Text,na.rm=FALSE){
	ngrams <- parse_to_ngram(Text,ngrams=2)
	x <- unlist(lapply(ngrams,query_ngram,na.rm=na.rm))
	dim(x) <- c(119,length(x)/119)

	if (!na.rm) attr(x,'ngrams') <- ngrams
	x
}

# To sum over all matches use
# rowSums(bigram_matches())

rApache_handler <- function(){
	ngram <- 0
	if(!is.null(GET$ngram))
		ngram <- as.integer(GET$ngram)

	if (ngram < 0 || ngram > 2)
		ngram <- 0

	text <- GET$text
	if (is.null(text))
		text <- POST$text
	if (is.null(text)) return(OK)

	
	if (ngram==0)
		text <- strsplit(text,',')[[1]]
	else
		text <- parse_to_ngram(text,ngrams=ngram)

	na.rm <- FALSE
	if (!is.null(GET$na.rm) && GET$na.rm=='1'){
	    na.rm <- TRUE
	}
	x <- ngram_matches(text,na.rm)
	y <- data.frame(x)

	if (!na.rm)
	    names(y) <- attr(x,'ngrams')

	write.csv(y,row.names=FALSE)
	OK
}
