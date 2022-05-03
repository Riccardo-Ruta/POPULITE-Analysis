# Explore dataset
# 27/04/22

###################################################
# Working directory from .Rproj
here::here("")

# Source setup scripts:-------------------------------------------------------------------
source(here::here("src","00_setup.R"))

# import tweets
#df <- read.csv("data/large_files/dataset_excell.csv",
 #              sep = ";",
  #             encoding = "utf-8")


# count NA observation for each variable [PROBABòY NOT WORKING]
for (i in colnames(df)) {
  print(paste(i, "-->", sum(is.na(df$i))))
}

# count missing observation not set as NA
sum(df=="")

# count missing observation for each variable [NOT WORKING]
for (i in colnames(df)) {
  print(i)
  print(sum(df$i==""))
}

# create the script for hard coded count of missing
for (i in colnames(df)) {
  print(paste("sum(df$",i,"=='')",sep= ""))
  }

# count missing for each variable hard coded
sum(df$ï..name =='')
sum(df$tweet_text =='')
sum(df$creato_il =='')
sum(df$creato_il_code =='')
sum(df$url =='')
sum(df$tw_screen_name =='')
sum(df$party_id =='')
sum(df$gender =='')
sum(df$X =='')

# create the script for hard coded length
for (i in colnames(df)) {
  print(paste("length(df$",i,")",sep= ""))
}

# length of each variable hard coded
length(df$ï..name)
length(df$tweet_text)
length(df$creato_il)
length(df$creato_il_code)
length(df$url)
length(df$tw_screen_name)
length(df$party_id)
length(df$gender)
length(df$X)

# Count the number of politicians with at least one tweets missing
df %>% filter(tweet_text== "") %>% distinct(ï..name) %>% count()

#####################################################
#03/05/2022

df <-  read_csv("data/large_files/politicians_all_final_tweets.csv")

# HOW MANY NA'S?
sum(is.na(df))

#where are NA's?
sum(is.na(df$df_screen_name))
which(is.na(df$tweet_testo))
sum(is.na(df$nome))
sum(is.na(df$url))
sum(is.na(df$party_id))
sum(is.na(df$creato_il))
sum(is.na(df$creato_il_code))
sum(is.na(df$genere))
sum(is.na(df$status))
sum(is.na(df$chamber))

# Check the variables
colnames(df)
