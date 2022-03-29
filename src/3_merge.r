#########################
#28/03/2022
#########################
###################################################
# Working directory from .Rproj
here::here("")

# Source setup scripts:-------------------------------------------------------------------
source(here::here("src","00_setup.R"))

# import the data
tw <- read.csv("data/large_files/TweetPopulite (1).csv", 
               sep = ";", encoding = "utf-8")#, escape_double = FALSE, trim_ws = TRUE)
View(tw)

colnames(tw)

# FILTER DATA REMOVING MISSING AND RETWEETS
filtered <- filter(tw,  id_pol != "#N/D" &
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
View(filtered)

#Adjust datetime
Sys.setlocale("LC_TIME", "C")

filtered$data <- as.Date(strptime(filtered$CreatoId,"%a %b %d %H:%M:%S %z %Y", tz = "CET"))


# FILTER FRATOIANNI DATA
frat <- filter(filtered, Cognome %like% "FRATOIANNI")

#Filter for a specific date 
frat_11_28 <- filter(frat, data %like% "11-28")

#Group Tweets by date
frat_uniti <- frat %>%
  group_by(data) %>%
  summarise(Tweet_uniti = paste(Tweet, collapse = ","))

#Add column with the count of the daily tweets  
frat_uniti$numero_tweet <- (frat %>% group_by(data) %>% count())[2]
count(distinct(frat$data))

frat_uniti$numero_tweet <- frat %>% goup(data) %>% count()




