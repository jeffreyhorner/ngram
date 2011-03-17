library(Rack)
ngram_url = 'http://app.rapache.net/ngram/'
fixup <- function(content){
    x <- gsub('^ *','',strsplit(Utils$unescape(content),',')[[1]])
    x <- gsub(' *$','',x)
    Utils$escape(paste(x,collapse=','))
}

lengthen_df <- function(x){
    xnames <- names(x)
    names(x) <- c(paste('count',seq(1,length(xnames)-1),sep='.'),'year')
    x <- reshape(x,varying=seq(1,length(xnames)-1),direction='long',timevar='ngram')
    x$ngram <- factor(xnames[x$ngram])
    x$prop <- x$count/sum(x$count)
    x
}

# For 1 and 2 gram queries separated by comma
ngram_query <- function(content,wide=FALSE){
    x <- read.csv(paste(ngram_url,'?text=',fixup(content),sep=''))
    if (wide) return(x)
    lengthen_df(cbind(x,year=seq(1890,2008)))
}

# for a single query on a whoe bunch of text chopped up
# as 2 grams
ngram_query2 <- function(content,wide=FALSE){
    erFun <- function(e) NULL
    x<- tryCatch(read.csv(paste(ngram_url,'?na.rm=1&ngram=2&text=',fixup(content),sep='')),error = erFun)
    if (!is.null(x)){
	x <- data.frame(lapply(x,as.numeric))
	if (wide) {
	    data.frame(x,x-rowMeans(x),year=seq(1890,2008))
	} else {
	    lengthen_df(cbind(x,year=seq(1890,2008)))
	}
    } else {
	NULL
    }
}
