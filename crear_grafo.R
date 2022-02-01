library(rtweet)
library(igraph)
library(tidyverse)
library(lubridate)

##CREO EL TOKEN EN BASE A MI APLICACIÓN EN TWITTER (https://developer.twitter.com/en/apps)
create_token(
  app = "mytwitterapp",
  consumer_key = "ywfcmWZk9wVIdlnJ81q1cJdHx",
  consumer_secret = "Koo4gMez3mclCEXczbchDGN1pQvBcCMnahQsYWP8b3Xo1omj3a",
  access_token = '879963143434362880-imeJhOUiRX9i0TX2mxmghkY9R23vSSb',
  access_secret = 'uJ5jATuLuNRxjfgSmCiCieLg8iTWvQpsNTsvdk8ogQeZ5',
  set_renv = TRUE
) -> twitter_token

#BAJO LOS TWEETS
#tweets.df <- search_tweets("search", n=250000,token=twitter_token,retryonratelimit = TRUE)

crawled_topics <- c()
for (crawled_topic in list.files(path = "datasets/Rdata files/", pattern = "*.RData")){
  crawled_topics <- rbind(crawled_topics, sub(".RData", "", crawled_topic))
}

pb0 = txtProgressBar(min = 0, max = length(list.files(path = "datasets/", pattern = "*-ids.txt")), initial = 0, style = 3)
j <- 0
for (dataset_file in list.files(path = "datasets/", pattern = "*-ids.txt")){
  dataset_name <- gsub("-ids.txt", "", dataset_file)
  j <- j + 1
  setTxtProgressBar(pb0, j)
  if (dataset_name %in% crawled_topics){
    next
  }
  print(dataset_name)
  
  ids <- read.table(paste0("datasets/" , dataset_file), header = FALSE)
  n <- 100
  nr <- nrow(ids)
  ids_chunks <- split(ids, rep(1:ceiling(nr/n), each=n, length.out=nr))
  pb = txtProgressBar(min = 0, max = length(ids_chunks), initial = 0, style = 3) 
  
  n_iter = length(ids) / n
  init <- numeric(n_iter)
  end <- numeric(n_iter)
  i <- 0
  L <- c()
  tweets.df <- data.frame()
  for (ids_chunk in ids_chunks) {
    init[i] <- Sys.time()
    
    temp.tweets.df <- lookup_statuses(ids_chunk[[1]],token=twitter_token)
    end[i] <- Sys.time()
    setTxtProgressBar(pb, i)
    i <- i + 1
    
    time <- round(seconds_to_period(sum(end - init)), 0)
    est <- n_iter * (mean(end[end != 0] - init[init != 0])) - time
    remainining <- round(seconds_to_period(est), 0)
    #if (i %% 10 == 0){
    #  cat(paste(" // Execution time:", time, " // Estimated time remaining:", remainining), "")
    #}
    #L <- c(list(temp.tweets.df), L)
    tweets.df <- rbind(tweets.df, temp.tweets.df)
  }
  
  net = network_graph(tweets.df, .e = c("retweet"))
  
  #save.image(paste0("datasets/Rdata files/", dataset_name, ".RData"))
}



#tweets.df <- do.call("rbind", L)


#tweets.df <- lookup_statuses(ids[[1]],token=twitter_token)


#CREO EL GRAFO DE RETWEETS
#net = network_graph(tweets.df, .e = c("retweet"))

#save.image("datasets/Rdata files/ukraine.RData")
#GENERO EL LAYOUT (PARA VISUALIZARLO)

#test <- read.table("datasets/ukraine-ids.txt", header = FALSE)
