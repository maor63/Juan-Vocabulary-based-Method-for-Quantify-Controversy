library(rtweet)
library(igraph)
library(tidyverse)
library(lubridate)
library(jsonlite)

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
    
    load(paste0("datasets/Rdata files/",dataset_name,".RData"))
    df <- dplyr::bind_rows(tweets.df)
    print(paste(dataset_name, 'ids count:', nrow(ids), 'crawled tweets count:', nrow(df), 'prec:',nrow(df) / nrow(ids)))
    #write.csv(tweets.df, paste0("datasets/tweet_data/",dataset_name,"_tweets.csv"), row.names = FALSE)
    #write.table(df , file = paste0("datasets/tweet_data/",dataset_name,"_tweets.csv"), sep=",", row.names=FALSE)
    write_json(df, paste0("datasets/tweet_data/",dataset_name,"_tweets.json"))
    
  }
}