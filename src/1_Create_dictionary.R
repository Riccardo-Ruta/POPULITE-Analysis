
###################################################
# Working directory from .Rproj
here::here("")

# Source setup scripts:-------------------------------------------------------------------
source(here::here("src","00_setup.R"))


#------------------------------
# import dictionaries file
dict <-  read_excel("data/populism_dictionaries.xlsx")
str(dict)
variable.names(dict)

# create the dictionary
Rooduijn_Pauwels_Italian <- dictionary(list(populism = (dict$Rooduijn_Pauwels_Italian[!is.na(dict$Rooduijn_Pauwels_Italian)])))

Grundl_Italian_adapted <- dictionary(list(populism = dict$Grundl_Italian_adapted[!is.na(dict$Grundl_Italian_adapted)]))

Decadri_Boussalis <- dictionary(list(populism = dict$Decadri_Boussalis[!is.na(dict$Decadri_Boussalis)]))

Decadri_Boussalis_Grundl <- dictionary(list(people = dict$Decadri_Boussalis_Grundl_People[!is.na(dict$Decadri_Boussalis_Grundl_People)],
                                           common_will = dict$`Decadri_Boussalis_Grundl_Common Will`[!is.na(dict$`Decadri_Boussalis_Grundl_Common Will`)],
                                           elite = dict$Decadri_Boussalis_Grundl_Elite[!is.na(dict$Decadri_Boussalis_Grundl_Elite)]))
#------------------------------

Rooduijn_Pauwels_Italian$populism

Grundl_Italian_adapted$populism

Decadri_Boussalis$populism

Decadri_Boussalis_Grundl$people
Decadri_Boussalis_Grundl$common_will
Decadri_Boussalis_Grundl$elite

#------------------------------

my_dictionary <- dictionary(list(populism = c(Rooduijn_Pauwels_Italian$populism,
                                              Grundl_Italian_adapted$populism,
                                              Decadri_Boussalis$populism,
                                              Decadri_Boussalis_Grundl$people,
                                              Decadri_Boussalis_Grundl$common_will,
                                              Decadri_Boussalis_Grundl$elite)))
my_dictionary$populism

