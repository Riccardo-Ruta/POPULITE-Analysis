# Add party_id = PD for Letta
 # import the data
 tw <-  read_csv("data/large_files/politicians_all_final_tweets.csv", show_col_types = FALSE )
 tw %>% filter(nome %like% "LETTA")
 tw2$party_id <- na.replace(tw$party_id, "PD")
 tw2 %>% filter(nome %like% "LETTA")
 write.csv(tw2, "data/large_files/politicians_final_corrected.csv", row.names = FALSE)
 