#Scraping and analyzing data from IMDb

library(rvest)
url = "https://www.imdb.com/search/title?year=2018"
imdb = read_html(url)
head(imdb)

#scrape the movie rankings
rank_data_html = html_nodes(imdb, '.lister-item-index unbold text-primary')
class(rank_data_html)
rank_data = html_text(rank_data_html)
head(rank_data)
class(rank_data)

#convert the rankings to numeric
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

#remove the 'min' annotation after the runtime
runtime_data = gsub(" min", "", runtime_data)
runtime_data = as.numeric(runtime_data)
head(runtime_data)

#scrape the movie genres
genre_data_html = html_nodes(imdb, ".genre")
genre_data = html_text(genre_data_html)
head(genre_data)

#remove the \n in front of the genres
genre_data = gsub("\n", "", genre_data)
head(genre_data)

#remove the spaces between genres
genre_data = gsub(" ", "", genre_data)
head(genre_data)

#display only the first genre in the list
genre_data = gsub(",.*", "", genre_data)
head(genre_data)

#create a dataframe with the scraped movie infos
imdb_df = data.frame(Title=title_data, Genre=genre_data, Runtime=runtime_data)

#descriptive stats
median(runtime_data)
mean(runtime_data)

#plot the number of movies by genre
#barplot(table(imdb_df$Genre))
library(ggplot2)
ggplot(imdb_df, aes(x=genre_data)) +
  geom_bar(color="purple", fill="green", alpha=0.3) +
  ggtitle("Number of movies by genre") +
  xlab("Genre") + ylab("Number of movies")

#plot the movies by runtime
barplot(table(imdb_df$Runtime))
hist(imdb_df$Runtime)
ggplot(imdb_df, aes(x=runtime_data)) +
  geom_histogram(color="purple", fill="green", alpha=0.3) +
  ggtitle("Distribution of movie runtimes") +
  xlab("Minutes") + ylab("Number of movies")

#group movies by genre
library(dplyr)
genre_cat = group_by(imdb_df, Genre)
genre_runtime = summarize(genre_cat, Minutes=mean(Runtime))
plot(genre_runtime)

counts = table(genre_runtime$Genre, genre_runtime$Minutes)
ggplot(data=genre_runtime, aes(x=Genre, y=Minutes)) +
  geom_bar(stat = "identity", color="purple", fill="green", alpha=0.3) +
  ggtitle("Mean movie duration by genre") 