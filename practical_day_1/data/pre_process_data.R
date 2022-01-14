library(tidyverse)
library(openxlsx)

# DATA is downloaded from https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE173201
# and belong to the study described here: https://pubmed.ncbi.nlm.nih.gov/34071702/
url <- "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE173nnn/GSE173201/suppl/GSE173201_DESEQ2_raw_counts.csv.gz"
temp_file <- tempfile()
download.file(url = url, destfile = temp_file)
data <- read_csv(gzfile(temp_file)) %>%
  subset(!is.na(gene_name) & !duplicated(gene_name))

# prepare count
counts <- data[, c(14, 5:7, 11:13)]
write_tsv(counts, file = "data/counts.tsv")

# prepare metadata
metadata <- data.frame(id = colnames(counts)[2:7]) %>%
  mutate(group = ifelse(grepl("A2780", id), "sensitive", "resistant"))
write_tsv(metadata, "data/metadata.tsv")
