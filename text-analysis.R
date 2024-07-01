# =========================================================
# Project: Trending Topic on Statistics - Midterm Project
# Author: [Noval]
# Description: This script performs text mining and sentiment analysis 
#              on Disneyland Tokyo reviews mined from Trip Advisor.
# =========================================================

# =========================================================
# Load Required Libraries
# =========================================================
# Load necessary libraries for text mining, sentiment analysis, 
# and visualization.
library(dplyr)       # Data manipulation
library(tidytext)    # Text mining
library(ggplot2)     # Data visualization
library(scales)      # Scales for visualization
library(tidyr)       # Data tidying
library(stringr)     # String operations
library(reshape2)    # Data reshaping
library(wordcloud)   # Word cloud generation
library(tm)          # Text mining
library(igraph)      # Network analysis
library(ggraph)      # Grammar of graphics for graphs
library(reshape2)    # Data reshaping

# =========================================================
# Load and Prepare Data
# =========================================================
# Load the Trip Advisor Disneyland Tokyo reviews dataset.
# Change the file path to the location where your CSV file is stored.
data <- read.csv("D:/.../Trip Advisor Disney Land Eng.csv", sep=";")
View(data) # View the dataset

# Rename the review column to 'text' and convert to a tibble.
text_df <- data %>% rename(text = Review) %>% as_tibble()

# =========================================================
# Tokenization and Stop Words Removal
# =========================================================
# Tokenize the text data into words and remove stop words.
tidy_reviews <- text_df %>%
  unnest_tokens(word, text)

data(stop_words) # Load default stop words
tidy_reviews <- tidy_reviews %>%
  anti_join(stop_words)

# =========================================================
# Word Frequency Analysis
# =========================================================
# Count the frequency of words and plot the most common words.
tidy_reviews %>%
  count(word, sort = TRUE)

# Plot words that appear more than 30 times.
tidy_reviews %>%
  count(word, sort = TRUE) %>%
  filter(n > 30) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)

# =========================================================
# Word Cloud
# =========================================================
# Create a word cloud of the most frequent words.
tidy_reviews %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100, colors = brewer.pal(8, "Dark2")))

# =========================================================
# Sentiment Analysis
# =========================================================
# Perform sentiment analysis using the Bing lexicon.
positive <- get_sentiments("bing") %>%
  filter(sentiment == "positive")

negative <- get_sentiments("bing") %>%
  filter(sentiment == "negative")

# Count positive and negative words.
tidy_reviews %>%
  inner_join(positive) %>%
  count(word, sort = TRUE)

tidy_reviews %>%
  inner_join(negative) %>%
  count(word, sort = TRUE)

# =========================================================
# Sentiment Barplot and Wordcloud
# =========================================================
# Create barplots and word clouds for positive and negative sentiments.
bing_word_counts <- tidy_reviews %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts %>%
  group_by(sentiment) %>%
  slice_max(n, n = 20) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment", y = NULL)

# Create a sentiment word cloud.
tidy_reviews %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red", "blue"), max.words = 100)

# =========================================================
# Sentiment Ratio Pie Chart
# =========================================================
# Calculate and plot the ratio of positive to negative sentiments.
total_sentiments <- tidy_reviews %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(ratio = positive / sum(positive, negative))

pie_data <- data.frame(
  Sentiment = c("Positive", "Negative"),
  Ratio = c(total_sentiments$positive, total_sentiments$negative),
  Percentage = c(total_sentiments$ratio * 100, (1 - total_sentiments$ratio) * 100)
)

ggplot(pie_data, aes(x = "", y = Ratio, fill = Sentiment)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  scale_fill_manual(values = c("salmon", "skyblue")) +
  labs(title = "Ratio of Positive to Negative Sentiments", fill = "Sentiment", caption = "Percentages are based on total sentiments") +
  theme_void() +
  theme(legend.position = "bottom") +
  geom_text(aes(label = paste0(round(Percentage), "%")), position = position_stack(vjust = 0.5))

# =========================================================
# Aspect-Based Sentiment Analysis
# =========================================================
# Extract and analyze sentiments for different aspects.

# Define a function to extract aspects from reviews.
extract_aspects <- function(tidy_reviews, aspect_words) {
  aspect_words <- paste(aspect_words, collapse = "|")
  tidy_reviews %>%
    filter(str_detect(word, aspect_words))
}

# Define aspect keywords for various aspects.
natural_aspect_words <- c("scenery", "landscape", "architecture", "attraction", "ride", "view")
activity_aspect_words <- c("activity", "entertainment", "show", "ride", "experience", "explore")
cleanliness_aspect_words <- c("clean", "tidy", "maintain", "hygiene", "sanitary")
access_aspect_words <- c("access", "transportation", "convenient", "easy", "accessible")
price_aspect_words <- c("price", "cost", "expensive", "affordable", "value", "ticket")

# Extract reviews for each aspect.
natural_reviews <- extract_aspects(tidy_reviews, natural_aspect_words)
activity_reviews <- extract_aspects(tidy_reviews, activity_aspect_words)
cleanliness_reviews <- extract_aspects(tidy_reviews, cleanliness_aspect_words)
access_reviews <- extract_aspects(tidy_reviews, access_aspect_words)
price_reviews <- extract_aspects(tidy_reviews, price_aspect_words)

# Define a function to plot bar plots for each aspect.
plot_aspect_bar <- function(aspect_reviews, aspect_name) {
  aspect_reviews %>%
    count(word) %>%
    top_n(10) %>%
    ggplot(aes(x = reorder(word, n), y = n)) +
    geom_bar(stat = "identity", fill = "skyblue") +
    labs(title = aspect_name, x = "Word", y = "Frequency") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    coord_flip()
}

# Plot bar plots for each aspect.
plot_aspect_bar(natural_reviews, "Scenery, Architecture, Rides")
plot_aspect_bar(activity_reviews, "Activities and Experiences")
plot_aspect_bar(cleanliness_reviews, "Cleanliness and Hygiene")
plot_aspect_bar(access_reviews, "Accessibility and Transportation")
plot_aspect_bar(price_reviews, "Ticket Price and Value")

# Load the necessary library for arranging multiple plots.
library(gridExtra)

# Arrange all plots in a 2x3 grid layout.
plot1 <- plot_aspect_bar(natural_reviews, "Scenery, Architecture, Rides")
plot2 <- plot_aspect_bar(activity_reviews, "Activities and Experiences")
plot3 <- plot_aspect_bar(cleanliness_reviews, "Cleanliness and Hygiene")
plot4 <- plot_aspect_bar(access_reviews, "Accessibility and Transportation")
plot5 <- plot_aspect_bar(price_reviews, "Ticket Price and Value")

grid.arrange(plot1, plot2, plot3, plot4, plot5, ncol = 3, nrow = 2)

# =========================================================
# Bigram Analysis
# =========================================================
# Perform bigram analysis to identify common word pairs.

# Tokenize the text data into bigrams.
tidy_bigrams <- text_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

# Separate the bigrams into individual words.
bigrams_separated <- tidy_bigrams %>%
  separate(bigram, into = c("word1", "word2"), sep = " ")

# Filter out stop words from the bigrams.
bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# Unite the words back into bigrams.
bigrams_united <- bigrams_filtered %>%
  unite(bigram, word1, word2, sep = " ")

# Count the frequency of bigrams.
bigram_counts <- bigrams_united %>%
  count(bigram, sort = TRUE)

# Plot frequent bigrams.
bigram_counts %>%
  filter(n > 5) %>%
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(n, bigram)) +
  geom_col() +
  labs(y = NULL, title = "Most Common Bigrams in Reviews") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_flip()

# Create a directed graph of bigrams.
bigram_graph <- graph_from_data_frame(bigram_counts, directed = TRUE)
E(bigram_graph)$weight <- bigram_counts$n

# Plot the bigram network graph.
ggraph(bigram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = weight, edge_width = weight), 
                 arrow = arrow(length = unit(0.15, "inches"), type = "closed"), 
                 end_cap = circle(0.1, 'inches'), 
                 edge_colour = "royalblue") +
  geom_node_point(size = 5, color = "dodgerblue") +
  geom_node_text(aes(label = name), vjust = 1.5, hjust = 1.5) +
  theme_void() +
  labs(title = "Bigram Network of Disneyland Tokyo Reviews",
       edge_width = "Frequency",
       edge_alpha = "Frequency")
