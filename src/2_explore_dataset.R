# Explore dataset
#03/05/2022


###################################################
# Working directory from .Rproj
here::here("")

# Source setup scripts:-------------------------------------------------------------------
source(here::here("src","00_setup.R"))

df <-  read_csv("data/large_files/politicians_all_final_tweets.csv")

# HOW MANY NA'S?
sum(is.na(df))

# Check the variables
colnames(df)

#where are NA's?
sum(is.na(df$tw_screen_name))
sum(is.na(df$tweet_testo)) # 6494
sum(is.na(df$nome))
sum(is.na(df$url)) # 147306
sum(is.na(df$party_id))
sum(is.na(df$creato_il))
sum(is.na(df$creato_il_code))
sum(is.na(df$genere))
sum(is.na(df$status))
sum(is.na(df$chamber))

