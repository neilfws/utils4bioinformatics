library(readr)
library(dplyr)
library(seqinr)
library(AhoCorasickTrie)

# should check this exists
words <- read_lines("~/Downloads/words_alpha.txt") %>% 
  toupper()

# should check this exists
sp <- read.fasta("~/Downloads/uniprot_sprot.fasta.gz", 
                 as.string = TRUE, 
                 seqtype = "AA")

# search & retain only hits
results <- AhoCorasickSearchList(words[which(nchar(words) > 7)], sp, alphabet = "aminoacid")
results <- results[which(sapply(results, function(x) length(x[[1]]) > 0))]

# subset into first & second hits then recombine
# my this is ugly

results01 <- results %>% 
  plyr::ldply(as.data.frame, stringsAsFactors = FALSE) %>% 
  as_tibble() %>% 
  select(.id, Keyword = Keyword.1, Offset = Offset.1) %>% 
  na.omit()

results02 <- results %>% 
  plyr::ldply(as.data.frame, stringsAsFactors = FALSE) %>% 
  as_tibble() %>% 
  select(.id, Keyword, Offset) %>% 
  na.omit()

word_matches <- bind_rows(results01, results02) %>% 
  arrange(desc(nchar(Keyword)))

# assumes running from code/R/
word_matches %>% write_csv("../../data/word_matches.csv")
