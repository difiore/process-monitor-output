# script to parse all .txt files in a "data" folder of output files
# and return a .csv file with the desired elements

library(tidyverse)
filenames <- list.files(
  "data", pattern = ".txt", full.names = TRUE
  )
# initialize results
results <- tibble(
  original_output_file=character(),
  survey_file_name=character(),
  template=character(),
  min.score=numeric(),
  max.score=numeric(),
  n.scores=numeric())

for (f in filenames){
  # initialize r
  r <- tibble(
    original_output_file=character(),
    survey_file_name=character(),
    template=character(),
    min.score=numeric(),
    max.score=numeric(),
    n.scores=numeric())
  d <- read_lines(f, skip_empty_rows = TRUE)
  # initialize vectors
  survey_file_name <- character()
  template <- character()
  min.score <- numeric()
  max.score <- numeric()
  n.scores <- numeric()
  # initialize index
  index <- 0
  for (i in 1:length(d)){ # loop through file line by line
    l <- str_split(d[i], "[ ]+")
    if (str_detect(l[[1]][1], "Based") ==TRUE){
      filename <- paste0(l[[1]][6], " ", l[[1]][7], " ", l[[1]][8])
    }
    if (str_detect(l[[1]][1], "F") ==TRUE){
      index <- index + 1
      survey_file_name[index] <- filename
      template[index] <- l[[1]][1]
      min.score[index] <- as.numeric(l[[1]][2])
      max.score[index] <- as.numeric(l[[1]][3])
      n.scores[index] <- as.numeric(l[[1]][4])
    }
  }
  r <- tibble(original_output_file=f, survey_file_name=survey_file_name, template=template,min.score=min.score, max.score=max.score, n.scores=n.scores)
  results <- bind_rows(results, r)
  # cleanup memory and workspace
  rm(list=c("r", "d", "l", "survey_file_name", "template", "min.score", "max.score", "n.scores", "index", "i", "filename"))
}
write_csv(results, "consolidated_output.csv")
# cleanup memory and workspace
rm(list=c("results", "filenames","f"))
