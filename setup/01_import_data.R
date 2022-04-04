#import data
#the first dataframe reports the politicians' id and their corresponding name
politicians <- read.csv("politicians_978.csv")

#the second dataframe is about .. 
mapping <- read.csv("mapping_784008.csv")

#the third dataframe contains the tweets id, the text from twitter and the number 
#of likes
#I had to use a different code
tweets <- read_delim("tweet_1.csv", delim = ";", 
                     escape_double = FALSE, col_types = cols(id = col_character()), 
                     trim_ws = TRUE)

#the following dataset contains the 4 dictionaries useful to run a sentiment 
#analysis
populism_dictionaries <- read_excel("populism_dictionaries.xlsx")
