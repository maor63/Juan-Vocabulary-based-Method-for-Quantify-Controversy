# Vocabulary-based-Method-for-Quantify-Controversy
Python and R code to identify automatically controversy on Twitter through text


## Requirements 

- R version 3.6.0
- R libraries
  - igraph
  - rtweet
  - tidyverse
  - readr
  - rgexf
  
- Python 3
- Python libraries
  - networkx
  - numpy
  - scipy
  
  ## Usage
  
- File "crear_grafo.R" download data by a hashtag or key word, creates the retweet graph and save enviroment
- Bash file "calcular" recieves as parameter the name of the saved enviroment and do the following steps:
  - Create training and test files for Fasttext
  - Train the NLP model
  - Predict tags
  - Measure controversy
  
-It is important to give permission to create files inside the folder and to give execution permission to file calcular if you want to use it
- Example: ./calcular bigil
  ## Datasets
  
Tweet's ids used in the paper are in dataset folder grouped by discussion.
 New datasets collected by crear_grafo.R will store in same folder.

In file datasets/Discussion descriptions.pdf there are detail descriptions about each discussion
