# Create a list of connections to all memcache searvers
eskape <- function(key) gsub(' ','|',key)
m <- lapply(readLines('memcache_ip.txt'),function(x)  mcConnect(paste(x,':11211',sep='')))
function MCGet <- function(key) lapply(m,function(x) mcGet(x,eskape(key)))
