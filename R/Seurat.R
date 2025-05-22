##============================================================================#
### Now writing. . .
### Last Modify: 25.05.22
### what is the function ?
### this script is made for using 'Seurat' library, 'interactively' by shiny app
#
###Build date: 
###Last update:
###How to use? 
##
#============================================================================#

library(shiny)
library(Seurat)


pbmc.data <- Read10X(data.dir = "/Users/edemhw/Personal_project/hg19")
pbmc <- CreateSeuratObject(counts = pbmc.data, project = "pbmc3k", min.cells = 3, min.features = 200)
