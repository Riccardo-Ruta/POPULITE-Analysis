#ALL TEST
###################################################
#test

# create my own function to accorp tweets
unisci <- function(x){
  x <- x %>%
    group_by(data) %>%
    summarise(Tweet = paste(Tweet, collapse = ","))
}

#############################################
for (i in 0:nrow(frat)) {
  frat$test <- paste(frat$Tweet[i])
}

frat$test <- paste(frat$Tweet[i])
#########################################
