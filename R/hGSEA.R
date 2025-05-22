#============================================================================#
###Build date: 2025.05.21 by CS
###Last update: 2025.05.21 by CS

###GSEA for multiple gene sets by for loop.
#============================================================================#

hGSEA <- function(data, 
                  genesets, 
                  exponent = "classic",
                  minGSSize = 10,
                  maxGSSize = 500,
                  eps = 1e-10,
                  pvalueCutoff = 0.05,
                  pAdjustMethod = "BH",
                  TERM2NAME = NA,
                  verbose = T,
                  seed = F,
                  by = "fgsea",
                  ...) {
  
  library(clusterProfiler)

#make temp list
  temp_result <- list()
  
#check the format of gene sets
  if(length(genesets) < 1) {
    stop("Wrong gene set. Please check the list.")
  } 
  
#check the format of the data file
#The data file must have 2 cols, 1st col's class is character, 2nd col's class is numeric
  if(ncol(data) != 2) {
    stop("Wrong data. Please check your data format")
  } else if(class(data[[1]]) != "character") {
    stop("Wrong data. First column's class is not 'character'")
  } else if(class(data[[2]]) != "numeric") {
    stop("Wrong data. Second column's class is not 'numeric'")
  }
  
# pre-processing of data
  names(data) <- c("gene", "logFC")
  max_abs_pos <- function(x) {
    max_abs <- max(abs(x))
    candidates <- x[abs(x) == max_abs]
    pos_max <- candidates[candidates > 0]
    if (length(pos_max) > 0) {
      return(pos_max[1])
    } else {
      return(candidates[1])
    }
  } #Select the value with the highest absolute value from duplicates.
  data <- aggregate(logFC ~ gene, data, max_abs_pos)
  data_vec <- data$logFC
  names(data_vec) <- data$gene
  data_vec <- sort(data_vec, decreasing = T)
    
  #check the exponent
  if(exponent == "classic" || is.null(exponent) || exponent == 0) {
    exponent <- 0
  }  else if (expoenent == "weight" || exponent == 1) {
    exponent <- 1
  } else {
    exponent <-1
  }
  
  for (i in seq_along(genesets)) {
      GSEA_df <- merge(data, genesets[i], by = "gene")
      if (nrow(GSEA_df) == 0) {
        warning("No matchiing gene with: ", names(genesets[i]))
        next
      }
      
      temp_df <- data.frame(Title = rep(names(genesets[i]), nrow(data)), Gene = genesets[[i]]$gene)
      
      GSEA_result <- clusterProfiler::GSEA(data_vec,
                                      TERM2GENE = temp_df,
                                      exponent = exponent,
                                      minGSSize = minGSSize,
                                      maxGSSize = maxGSSize,
                                      eps = eps,
                                      pvalueCutoff = pvalueCutoff,
                                      pAdjustMethod = pAdjustMethod,
                                      TERM2NAME = TERM2NAME,
                                      verbose = verbose,
                                      seed = seed,
                                      by = by)
      
      result_name <- names(genesets[i])
      temp_result[[result_name]] <- GSEA_result
    }

  return(temp_result)
}

test <- hGSEA(data, genesets)

