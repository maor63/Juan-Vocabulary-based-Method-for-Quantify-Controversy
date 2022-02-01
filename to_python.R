library(readr)
library('plyr')
library('dplyr')

args = commandArgs(trailingOnly=TRUE)
fileName0 = args[1]
#fileName0 = "bigil"
load(paste0("datasets/communities/",fileName0,".RData"))
#dataset <- read_csv(paste0('datasets/fasttext_train_predict_files/',fileName0,'.csv'),
#                       col_names = FALSE)
dataset <- read.csv(paste0('datasets/fasttext_train_predict_files/',fileName0,'.csv'),
                    header = FALSE, sep=' ')
print(fileName0)
predicted = dataset
tweets.df_score = users_text
tweets.df_score$topic1 = predicted$V2

tweets.df_score$topic1[predicted$V1 == "__label__2"] = -predicted$V2[predicted$V1 == "__label__2"]

users_mean<-ddply(tweets.df_score,~screen_name,summarise,mean_topic=mean(as.numeric(topic1)))

library("igraph")
library(rgexf)
net2 = net
E(net2)$text = ''
#net2 = delete_vertex_attr(net2,"size")
Isolated = which(degree(net2)<3)
net2 = delete.vertices(net2, Isolated)

users_mean = users_mean[order(users_mean$mean_topic),]
users_mean = users_mean[which(paste0('',users_mean$screen_name) %in% V(net2)$name),]

V(net2)$ideo =0
V(net2)$ideo[V(net2)$name %in% paste0('',users_mean$screen_name[(users_mean$mean_topic > 0.90)]) ] = users_mean$mean_topic[(users_mean$mean_topic > 0.9)]
V(net2)$ideo[V(net2)$name %in% paste0('',users_mean$screen_name[(users_mean$mean_topic < -0.90)])] = users_mean$mean_topic[(users_mean$mean_topic < -0.9)]
#V(net2)$ideo[V(net2)$name %in% paste0('@',users_mean_1$screen_name) ] = 1
#V(net2)$ideo[V(net2)$name %in% paste0('@',users_mean_2$screen_name)] = -1

to = length(V(net2))-1
V(net2)$label = c(0:to)
V(net2)$label2 = c(0:to)
#write_graph(as.undirected(simplify(net2)), paste0("datasets/graphs/",fileName0,"_r.gml"), format = "gml")
write_graph(simplify(net2), paste0("datasets/graphs/",fileName0,"_r.gml"), format = "gml")

print(fileName0)
