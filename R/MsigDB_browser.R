#============================================================================#
###Build date: 2025.05.16 by CS
###How to use? 
## 1. 1st parameter species = "Hu" or "Mm", Human or Mouse.
## 2. 2nd parameter name = gene set's name, Just copy and paste from MsigDB.
#============================================================================#
### plan: use 'for loop' and make it can get multiple gene sets!

install.packages("jsonlite")
library(jsonlite)

msigdb.browse <- function(species, name) {
  if(species == "Hu") {
    geneset_path <- paste0("https://www.gsea-msigdb.org/gsea/msigdb/human/download_geneset.jsp?geneSetName=", name ,"&fileType=json")
  } else if (species == "Mm") {
    geneset_path <- paste0("https://www.gsea-msigdb.org/gsea/msigdb/mouse/download_geneset.jsp?geneSetName=", name ,"&fileType=json")
  } else {
    cat("It's a specie that doesn't support.")
  }
  temp <- fromJSON(geneset_path)
  temp_list <- c(list("gene"), temp[[1]]$geneSymbols)
  geneset <- data.frame(gene = unlist(temp_list))
  # if you wanna delete 'gene' from 1st row,
  # Hu_geneset_list <- data.frame(gene = temp_df[[1]]$geneSymbols)
  
  
  return(geneset)
}

Hu_test_df <- msigdb.browse("Hu", "GOBP_CELLULAR_SENESCENCE")
Mm_test_df <- msigdb.browse("Mm", "ABBUD_LIF_SIGNALING_1_DN")
