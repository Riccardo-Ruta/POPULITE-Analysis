# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))
#--------------------------------------

# Preliminar analysis [RUN 4_CORPUS.R BEFORE THIS SCRIPT]

# Create a DFM (Bag of word approach, non positional)
doc.dfm <- dfm(doc.tokens, tolower = T)

# top features
topfeatures(doc.dfm, 20)

# Dfm trimming:only words that occur in the top 20% of the distribution and in less than 30% of documents
# very frequent but document specific words
doc.dfm <- dfm_trim(doc.dfm, min_termfreq = 0.80, termfreq_type = "quantile",
                    max_docfreq = 0.3, docfreq_type = "prop")

# Check top features after trimming
topfeatures(doc.dfm, 20)

# Plot the frequency of the top features in a text using the topfeatures.
system.time(features_dfm <- textstat_frequency(doc.dfm, n = 20))
features_dfm

# plot with GGPLOT
ggplot(features_dfm, aes(x = feature, y = frequency)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Extract most common hashtags
tag_dfm <- dfm_select(doc.dfm, pattern = "#*")
toptag <- names(topfeatures(tag_dfm, 20))
head(toptag)

# Construct feature-occurrence matrix of hashtags
tag_fcm <- fcm(tag_dfm)
head(tag_fcm)

topgat_fcm <- fcm_select(tag_fcm, pattern = toptag)
textplot_network(topgat_fcm, min_freq = 0.1, edge_alpha = 0.8, edge_size = 5)

# Extract most frequently mentioned usernames
user_dfm <- dfm_select(doc.dfm, pattern = "@*")
topuser <- names(topfeatures(user_dfm, 20))
head(topuser)

#Construct feature-occurrence matrix of usernames
user_fcm <- fcm(user_dfm)
head(user_fcm)

user_fcm <- fcm_select(user_fcm, pattern = topuser)
textplot_network(user_fcm, min_freq = 0.1, edge_color = "orange", edge_alpha = 0.8, edge_size = 5)