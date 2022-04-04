#some statistics
tokeninfo <- summary(tweets_corpus)

tokeninfo$Year <- docvars(tweets_corpus, "year")

ggplot(data = tokeninfo, aes(x = year, y = Tokens, group = 1)) +
  geom_line() + geom_point() + scale_x_continuous(labels = c(seq(2020, 2022)),
                                                  breaks = seq(1789, 2017)) + 
  theme_bw()

#largest tweet
tokeninfo[which.max(tokeninfo$Tokens), ]
tweets$text[98]


