# 10 : 50 iter 1000
top1 <- c(10:50)

## let's create an empty data frame
risultati <- data.frame(first=vector(), second=vector(), third=vector()) 

system.time(
  for (i  in top1) 
  { 
    set.seed(123)
    lda_test <- LDA(dtm, method= "Gibbs", k = (i),  control=list(verbose=50L, iter=1000))
    topic <- (i)
    coherence_test <- mean(topic_coherence(lda_test, dtm))
    exclusivity_test <- mean(topic_exclusivity(lda_test))
    risultati <- rbind(risultati , cbind(topic, coherence_test, exclusivity_test ))
  }
)
# save(risultati,file="data/results_K_10-50.Rda")

# VISUALIZE RESULTS
plot5 <- as.ggplot(~plot(risultati$coherence_test, risultati$exclusivity_test, main="Scatterplot k=10:50",
                         xlab="Semantic Coherence", ylab="Exclusivity ", pch=19,
                         col=ifelse(risultati$coherence_test<=-7 | risultati$exclusivity_test<9.7 ,"black","red")) + 
                     text(risultati$coherence_test,
                          risultati$exclusivity_test, labels=risultati$topic, cex= 1,  pos=4))
plot5

######################
# SELECT K = 22

system.time(lda_22 <- LDA(dtm, method= "Gibbs", k = 22, control = list(seed = 123)))
save(lda_22, file = "data/lda_k_22.Rda")



