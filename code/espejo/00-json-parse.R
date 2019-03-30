# * THE FOLLOWING SCRIPT FOLLOWS DIRECTIONS FROM
# * URL: https://blog.exploratory.io/working-with-json-data-in-very-simple-way-ad7ebcc0bb89

library(jsonlite)
library(tibble)
library(dplyr)
library(tidyr)
library(stringr)

json <- "Downloads/yelp_dataset/business.json"
yelp <- stream_in(file(json))
yelp <- flatten(yelp)
yelp <- as_data_frame(yelp)


yelp <- yelp %>% select(-starts_with("hours"), -starts_with("attribute"))
yelp <- yelp %>% mutate(categories = as.character(categories))
dim(yelp)

head(yelp)
names(yelp)
nrow(yelp)

