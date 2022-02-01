####USAR CONTEXTOS DE modelos_agrupados_09
library("plyr")
library("igraph")
library("textclean")
communitiesQuantity <- 2
args = commandArgs(trailingOnly=TRUE)
fileName0 = args[1]
#fileName0 = "bigil"
#load(paste0("datasets/Rdata files/",fileName0,".RData"))
load(paste0("datasets/juan_original_rdata/",fileName0,".RData"))
fileName = fileName0
print(fileName)

#my.com.fast <- walktrap.community(net)
my.com.fast <-cluster_louvain(as.undirected(simplify(net)))
largestCommunities <- order(sizes(my.com.fast), decreasing=TRUE)[1:communitiesQuantity]
community1 <- names(which(membership(my.com.fast) == largestCommunities[1]))
community2 <- names(which(membership(my.com.fast) == largestCommunities[2]))
users_text<-ddply(tweets.df,~screen_name,summarise,text=paste(text, collapse = " "))
if(length(unique(users_text$text[which(paste('',users_text$screen_name,sep="") %in% community1)] )) > length(unique(users_text$text[which(paste('@',users_text$screen_name,sep="") %in% community2)]) ) ){
  to = length(unique(users_text$text[which(paste('',users_text$screen_name,sep="") %in% community2)] ))
}else{
  to = length(unique(users_text$text[which(paste('',users_text$screen_name,sep="") %in% community1)] ))
}

fileConn<-file(paste0("datasets/fasttext_train_predict_files/",fileName,"-train.txt"), 'w')
text<-users_text$text[which(paste('',users_text$screen_name,sep="") %in% community1)] 
text <- unique(text)
# Here we pre-process the data in some standard ways. I'll post-define each step
#text <- iconv(text, to = "ASCII", sub = " ")  # Convert to basic ASCII text to avoid silly characters
text<- replace_emoji(text)
text <- tolower(text)  # Make everything consistently lower case
text <- gsub("rt", " ", text)  # Remove the "RT" (retweet) so duplicates are duplicates
text <- gsub("@\\w+", " ", text)  # Remove user names (all proper names if you're wise!)
text <- gsub("http.+ |http.+$", " ", text)  # Remove links
text <- gsub("[[:punct:]]", " ", text)  # Remove punctuation
text <- gsub("[ |\t]{2,}", " ", text)  # Remove tabs
#text <- gsub("amp", " ", text)  # "&" is "&amp" in HTML, so after punctuation removed ...
text <- gsub("^ ", "", text)  # Leading blanks
text <- gsub(" $", "", text)  # Lagging blanks
text <- gsub(" +", " ", text) # General spaces (should just do all whitespaces no?)
text <- gsub("\n", " ", text) # General spaces (should just do all whitespaces no?)
#text <- unique(text)  # Now get rid of duplicates!

for(is in 1:to){
  write(paste("__label__1 , ",text[is]), file=fileConn,append=TRUE)
}
#close(fileConn)
#fileConn<-file("tweets_kavenaugh_02-05-test-d.txt", 'w')
text<-users_text$text[which(paste('',users_text$screen_name,sep="") %in% community2)] 
text <- unique(text)
# Here we pre-process the data in some standard ways. I'll post-define each step
#text <- iconv(text, to = "ASCII", sub = " ")  # Convert to basic ASCII text to avoid silly characters
text<- replace_emoji(text)
text <- tolower(text)  # Make everything consistently lower case
text <- gsub("rt", " ", text)  # Remove the "RT" (retweet) so duplicates are duplicates
text <- gsub("@\\w+", " ", text)  # Remove user names (all proper names if you're wise!)
text <- gsub("http.+ |http.+$", " ", text)  # Remove links
text <- gsub("[[:punct:]]", " ", text)  # Remove punctuation
text <- gsub("[ |\t]{2,}", " ", text)  # Remove tabs
text <- gsub("amp", " ", text)  # "&" is "&amp" in HTML, so after punctuation removed ...
text <- gsub("^ ", "", text)  # Leading blanks
text <- gsub(" $", "", text)  # Lagging blanks
text <- gsub(" +", " ", text) # General spaces (should just do all whitespaces no?)
text <- gsub("\n", " ", text) # General spaces (should just do all whitespaces no?)
#text <- unique(text)  # Now get rid of duplicates!

for(is in 1:to){
  write(paste("__label__2 , ",text[is]), file=fileConn,append=TRUE)
}
close(fileConn)

net2 = components(net, mode = "weak")
Big = V(net)[which(net2$membership == which.max(net2$csize))]$name
tweets.df.no.retweet = tweets.df[tweets.df$is_retweet==FALSE,]
users_text<-ddply(tweets.df.no.retweet,~screen_name,summarise,text=paste(text, collapse = " "))
users_text = users_text[which(paste('',users_text$screen_name,sep="") %in% Big),]
text<-users_text$text[which(paste('',users_text$screen_name,sep="") %in% Big)]
#text <- iconv(text, to = "ASCII", sub = " ")  # Convert to basic ASCII text to avoid silly characters
text<- replace_emoji(text)
text <- tolower(text)  # Make everything consistently lower case
text <- gsub("rt", " ", text)  # Remove the "RT" (retweet) so duplicates are duplicates
text <- gsub("@\\w+", " ", text)  # Remove user names (all proper names if you're wise!)
text <- gsub("http.+ |http.+$", " ", text)  # Remove links
text <- gsub("[[:punct:]]", " ", text)  # Remove punctuation
text <- gsub("[ |\t]{2,}", " ", text)  # Remove tabs
text <- gsub("amp", " ", text)  # "&" is "&amp" in HTML, so after punctuation removed ...
text <- gsub("^ ", "", text)  # Leading blanks
text <- gsub(" $", "", text)  # Lagging blanks
text <- gsub(" +", " ", text) # General spaces (should just do all whitespaces no?)
text <- gsub("\n", " ", text) # General spaces (should just do all whitespaces no?)
fileConn<-file(paste0("datasets/fasttext_train_predict_files/", fileName,"-to-predict.txt"), 'w')
for(is in 1:length(text)){
  write(paste("",text[is]), file=fileConn,append=TRUE)
}
close(fileConn)
save.image(paste0("datasets/communities/",fileName,".RData"))
