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
# FILTER DATA REMOVING MISSING AND RETWEETS
filtered_2 <- filter(tw,  id_pol != "#N/D" &
                       id_tw_user != "#N/D" &
                       id_tweet != "#N/D" &
                       Url != "#N/D" &
                       Cognome != "#N/D" &
                       Nome != "#N/D" &
                       Genere!= "#N/D" &
                       GruppoPolitico != "#N/D" &
                       Tweet != "#N/D" &
                       CreatoId != "#N/D" &
                       CreatoIlCodice!= "#N/D" &
                       !Tweet %like% "RT" )
###############################################
