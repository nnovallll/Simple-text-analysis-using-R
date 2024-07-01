# Trending Topic on Statistics - Midterm Project

This repository contains my midterm project for the course **Trending Topic on Statistics**. The project focuses on analyzing reviews of Disneyland Tokyo using statistical methods and data analysis techniques.

## Project Overview

The aim of this project is to identify and analyze current trends in the reviews of Disneyland Tokyo. By leveraging text mining and sentiment analysis, we perform exploratory data analysis (EDA), sentiment analysis, and aspect-based sentiment analysis to gain insights into the sentiments and aspects prevalent in the reviews.

## Data

The data used in this project consists of reviews of Disneyland Tokyo, mined from Trip Advisor. The dataset is stored in the file `Trip Advisor Disney Land Eng.csv`.

## Key Features

- **Data Collection**: Gathering reviews data from Trip Advisor.
- **Text Cleaning and Tokenization**: Cleaning the text data and tokenizing it into words.
- **Stop Words Removal**: Removing common stop words to focus on meaningful words.
- **Word Frequency Analysis**: Counting the frequency of words and visualizing the most common words.
- **Word Cloud**: Creating a word cloud to visualize the most frequent words.
- **Sentiment Analysis**: Analyzing the sentiments of the reviews using the Bing lexicon.
- **Aspect-Based Sentiment Analysis**: Extracting and analyzing sentiments for different aspects like natural beauty, activities, cleanliness, accessibility, and price.
- **Bigram Analysis**: Analyzing pairs of consecutive words (bigrams) and visualizing the bigram network.

## Tools and Technologies

- **Programming Language**: R
- **Libraries**: dplyr, tidytext, ggplot2, scales, tidyr, stringr, reshape2, wordcloud, tm, igraph, ggraph, gridExtra

## How to Use This Repository

1. **Clone the repository**:
   ```bash
   git clone https://github.com/username/trending-topic-on-statistics.git
   ```
2. **Open the R script**: Use an R environment like RStudio to run the analysis scripts.
3. **Run the analysis**: Open and run the R script `analysis.R` to reproduce the analysis and results.

## Analysis Steps

The analysis is structured in the following steps:

1. **Load Libraries**: Load the necessary R libraries.
2. **Data Import and Preparation**: Import the review data and prepare it for analysis.
3. **Tokenization and Stop Words Removal**: Tokenize the text data into words and remove stop words.
4. **Word Frequency Analysis**: Analyze and visualize the frequency of words.
5. **Word Cloud**: Create a word cloud to visualize the most frequent words.
6. **Sentiment Analysis**: Perform sentiment analysis using the Bing lexicon.
7. **Aspect-Based Sentiment Analysis**: Extract and analyze sentiments for different aspects.
8. **Bigram Analysis**: Perform bigram analysis and visualize the bigram network.

For detailed syntax and code, please refer to the [text-analysis.R](text-analysis.R) file in this repository.

## Results and Findings

The detailed analysis and results are documented in the `text-analysis.R` script and visualizations provided in this repository. Key findings and insights are summarized in the final report.

## Contributing

If you have suggestions or improvements, feel free to create an issue or submit a pull request. Contributions are welcome!
