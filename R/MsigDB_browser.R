#============================================================================#
###Build date: 2025.05.16 by CS
###Last update: 2025.05.19 by CS
###How to use? 
## 1. 1st parameter species = "Hu" or "Mm", Human or Mouse.
## 2. 2nd parameter name = gene set's name, Just copy and paste from MsigDB.
#============================================================================#

install.packages("jsonlite")
library(jsonlite)

msigdb.browse <- function(species, name) {
  library(jsonlite)
  
  if(species == "Hu") {
    geneset_path <- "https://www.gsea-msigdb.org/gsea/msigdb/human/download_geneset.jsp?geneSetName="
  } else if (species == "Mm") {
    geneset_path <- "https://www.gsea-msigdb.org/gsea/msigdb/mouse/download_geneset.jsp?geneSetName="
  } else {
    stop("It's a specie that doesn't support.")
  }
  
  temp.list <- c()
  
  temp.list <- lapply(name, function(n) {
    geneset_url <- paste0(geneset_path, n, "&fileType=json")
    temp <- fromJSON(geneset_url)
    temp_gene <- c(list("gene"), temp[[1]]$geneSymbols)
    geneset <- data.frame(gene = unlist(temp_gene))
    return(geneset)
  })
  
  
  
  
  # if you wanna delete 'gene' from 1st row,
  # geneset <- data.frame(gene = temp_df[[1]]$geneSymbols)
  
  names(temp.list) <- name
  return(temp.list)
}

Hu_test_df <- msigdb.browse("Hu", geneset_list)
Mm_test_df <- msigdb.browse("Mm", "ABBUD_LIF_SIGNALING_1_DN")
