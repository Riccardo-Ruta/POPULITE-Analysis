#Find the number of topics (k)

# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))

# Load dfm trimmed
load("data/dfm_trimmed.Rda")

dtm <- quanteda::convert(DFM_trimmed, to = "topicmodels")

##############################################################################
# 20 : 80
top1 <- c(20:80)

## let's create an empty data frame
results1 <- data.frame(first=vector(), second=vector(), third=vector()) 

system.time(
  for (i  in top1) 
  { 
    set.seed(123)
    lda1 <- LDA(dtm, method= "Gibbs", k = (i),  control=list(verbose=50L, iter=1000))
    topic <- (i)
    coherence <- mean(topic_coherence(lda1, dtm))
    exclusivity <- mean(topic_exclusivity(lda1))
    results1 <- rbind(results1 , cbind(topic, coherence, exclusivity ))
  }
)
 save(results1,file="data/results_K_20-80.Rda")


##################################################################################
# 70 : 90
 top2 <- c(70:90)
 
 results2 <- data.frame(first=vector(), second=vector(), third=vector()) 
 
 system.time(
   for (i  in top2) 
   { 
     set.seed(123)
     lda2 <- LDA(dtm, method= "Gibbs", k = (i),  control=list(verbose=50L, iter=10))
     topic <- (i)
     coherence <- mean(topic_coherence(lda2, dtm))
     exclusivity <- mean(topic_exclusivity(lda2))
     results2 <- rbind(results2 , cbind(topic, coherence, exclusivity ))
   }
 )
 
  save(results2,file="data/results_K_70-90.Rda") 


###########################################################################
# 10 : 40
top3 <- c(10:40)

## let's create an empty data frame
results3 <- data.frame(first=vector(), second=vector(), third=vector()) 

system.time(
  for (i  in top_3) 
  { 
    set.seed(123)
    lda1 <- LDA(dtm, method= "Gibbs", k = (i),  control=list(verbose=50L, iter=1000))
    topic <- (i)
    coherence <- mean(topic_coherence(lda1, dtm))
    exclusivity <- mean(topic_exclusivity(lda1))
    results3 <- rbind(results3 , cbind(topic, coherence, exclusivity ))
  }
)
 save(results3,file="data/results_k_10-40.Rda")
 
 
#########################################################################
# 5 : 20
top4 <- c(5:20)

## let's create an empty data frame
results4 <- data.frame(first=vector(), second=vector(), third=vector()) 

system.time(
 for (i  in top4) 
 { 
   set.seed(123)
   lda1 <- LDA(dtm, method= "Gibbs", k = (i),  control=list(verbose=50L, iter=2000))
   topic <- (i)
   coherence <- mean(topic_coherence(lda1, dtm))
   exclusivity <- mean(topic_exclusivity(lda1))
   results4 <- rbind(results4 , cbind(topic, coherence, exclusivity ))
 }
)
 save(results4,file="data/results_k_5-20.Rda") 

 