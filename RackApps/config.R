library(lattice)
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
		res$write(capture.output(brew(file_path,envir=opt,chdir=TRUE)))
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

	},
	'/?' = function(env){
	    req <- Rack::Request$new(env)
	    res <- Rack::Response$new()
	    res$redirect(req$to_url('/brew/index.rhtml'))
	    res$finish()
	}
    )
)
