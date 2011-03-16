library(ggplot2)
library(brew)
source('library.R')

Brewery <- setRefClass(
    'Brewery',
    contains = 'Middleware',
    fields = c('url','root','opt'),
    methods = list(
	initialize = function(url,root,...){
	    url <<- paste('^',url,sep='')
	    root <<- root
	    lopts <- list(...)
	    if (length(lopts))
		opt <<- list2env(list(...))
	    else
		opt <<- new.env()
	    callSuper()
	},
	call = function(env){
	    req <- Rack::Request$new(env)
	    res <- Rack::Response$new()
	    opt[['req']] <<- req;
	    opt[['res']] <<- res;
	    path = env[["PATH_INFO"]]
	    file_path = file.path(root,path)
	    if (length(grep(url,path))>0 && file.exists(file_path)){
		oldwd <- setwd(dirname(file_path))
		on.exit(setwd(oldwd))
		res$write(capture.output(brew(basename(file_path),envir=opt)))
		res$finish()
	    } else
		app$call(env)
	}
    )
)
dir.create(file.path(tempdir(),'plots'),showWarnings=FALSE)
app <- Rack::Builder$new(
    Brewery$new('/brew','.'),
    Rack::URLMap$new(
	'/graph' = function(env){
	    req <- Rack::Request$new(env)
	    content <- req$GET()$content
	    if (is.null(content))
		content <- 'Atlantis, El Dorado'
	    data <- ngram_query(content)
	    t <- paste(tempfile(),'.png',sep='')
	    png(filename=t,width=900,height=330)
            p <- ggplot(data,aes(x=year,y=count,grouping=ngram))
	    print(p + geom_line(aes(colour=ngram)) + scale_y_log10() + ylab("Log (count)"))
	    dev.off()
	    fi <- file.info(t)
	    body <- t
	    names(body) <- 'file'
	    list (
		status=200L,
		headers = list(
		    'Last-Modified' = Utils$rfc2822(fi$mtime),
		    'Content-Type' = Mime$mime_type(Mime$file_extname(t)),
		    'Content-Length' = as.character(fi$size)
		),
		body=body
	    )
	},
	'/?' = function(env){
	    req <- Rack::Request$new(env)
	    res <- Rack::Response$new()
	    res$redirect(req$to_url('/brew/index.rhtml'))
	    res$finish()
	}
    )
)
