#Need to develop for function

library(KEGGREST)

keggList("hsa")

hsa04613 <- keggGet("hsa04613")
hsa04613_g <- data.frame(gene = hsa04613[[1]]$GENE)
NETs_HGNC <- data.frame(gene = hsa04613_g[seq(2, nrow(hsa04613_g), by = 2), ])
NETs_HGNC <- sub(";.*", "", NETs_HGNC$gene)
NETs_ID <- hsa04613_g[seq(1, nrow(hsa04613_g), by = 2), ]
