#Extract and analyze data from IMDB

library(rvest)
url = "https://www.imdb.com/search/title?year=2018"
imdb = read_html(url)
head(imdb)

rank_data_html = html_nodes(imdb, '.lister-item-index unbold text-primary')
class(rank_data_html)

rank_data = html_text(rank_data_html)
head(rank_data)
class(rank_data)

#convert to numeric
rank_data = as.numeric(rank_data) 
head(rank_data)
class(rank_data)

#scrape the movie titles
title_data_html = html_nodes(imdb, '.lister-item-header a')
#convert the titles to text
title_data = html_text(title_data_html)
head(title_data)

#scrape the runtime of the movies
runtime_data_html = html_nodes(imdb, " .runtime")
runtime_data = html_text(runtime_data_html)
head(runtime_data)
#remove the 'min' annotation
runtime_data = gsub(" min", "", runtime_data)
runtime_data = as.numeric(runtime_data)
head(runtime_data)

#scrape the movie genres
genre_data_html = html_nodes(imdb, ".genre")
genre_data = html_text(genre_data_html)
head(genre_data)
#clean the genre names
genre_data = gsub("\n", "", genre_data)
head(genre_data)
genre_data = gsub(" ", "", genre_data)
head(genre_data)
#display only the first genre
genre_data = gsub(",.*", "", genre_data)
head(genre_data)

#create a dataframe with the movies info
imdb_df = data.frame(Rank=rank_data, Title=title_data, Genre=genre_data, Runtime=runtime_data)

#plot the number of movies by genre
barplot(table(imdb_df$Genre))

#plot the movies by runtime
barplot(table(imdb_df$Runtime))
hist(imdb_df$Runtime)

#group movies by genre
library(dplyr)
genre_cat <- group_by(imdb_df, Genre)
genre_runtime <- summarize(genre_cat, avg_min=mean(Runtime))
plot(genre_runtime)

counts <- table(genre_runtime$Genre, genre_runtime$avg_min)
library(ggplot2)
ggplot(data=genre_runtime, aes(x=Genre, y=avg_min)) + geom_bar(stat = "identity")