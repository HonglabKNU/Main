#markers by Azimuth_Bone Marrow
library(officer)
library(rvg)

BM_markers <- list("B" = unlist(strsplit("FCRL1,FCRL2,CD22,ARHGAP24,BANK1,MS4A1,RALGPS2,CD37,SWAP70,CD79A", ",")),
                   "CD4 T" = unlist(strsplit("MAL,LEF1,IL7R,TCF7,LTB,LEPROTL1,CD3E,CD3D,CD3G,CD27", ",")),
                   "CD8 T" = unlist(strsplit("CD8B,CD8A,NELL2,CD3D,CD3E,S100B,GZMH,CD3G,TRGC2,CCL5",",")),
                   "DC" = unlist(strsplit("CLEC4C,PROC,SCT,SCN9A,SHD,PPM1J,ENHO,CLEC10A,LILRA4,DNASE1L3", ",")),
                   "HSPC" = unlist(strsplit("ARPP21,CFAP73,AVP,SPTA1,EPCAM,RHCE,AKAP12,RHAG,C1QTNF4,CYTL1", ",")),
                   "Mono" = unlist(strsplit("LYPD2,FOLR3,CLEC4E,LILRA1,CDA,RBP7,CD300LF,FPR1,CD93,MTMR11", ",")),
                   "NK" = unlist(strsplit("NCR1,SH2D1B,KLRC1,PRSS23,CD160,B3GNT7,IL2RB,IL18RAP,XCL1,KLRF1", ",")),
                   "Other T" = unlist(strsplit("SLC4A10,KLRB1,IL7R,TNFRSF25,RORA,SPOCK2,MAF,GZMK,ZFP36L2,LYAR", ",")))

VlnPlot(data, features = unlist(strsplit("LYPD2,FOLR3,CLEC4E,LILRA1,CDA,RBP7,CD300LF,FPR1,CD93,MTMR11", ",")))
FeaturePlot(data, features = unlist(strsplit("LYPD2,FOLR3,CLEC4E,LILRA1,CDA,RBP7,CD300LF,FPR1,CD93,MTMR11", ",")))

ppt <- read_pptx()
for(i in seq_along(BM_markers)){
  temp1 <- VlnPlot(data, features = BM_markers[[i]])
  temp1 <- temp1 + patchwork::plot_annotation(paste(names(BM_markers[i]), ", Outcome: ", length(temp1), " / Total: ", length(BM_markers[[i]])))
  temp2 <- FeaturePlot(data, features = BM_markers[[i]]) 
  temp2 <- temp2 + patchwork::plot_annotation(paste(names(BM_markers[i]), ", Outcome: ", length(temp2), " / Total: ", length(BM_markers[[i]])))
  
  ppt %>% add_slide(layout = "Blank", master = "Office Theme") %>% 
    ph_with(
      dml(ggobj = temp1),
      location = ph_location_fullsize()
    ) %>% add_slide(layout = "Blank", master = "Office Theme") %>% 
    ph_with(
      dml(ggobj = temp2),
      location = ph_location_fullsize()
    )
  rm(temp1, temp2)
}

#ppt
print(ppt, target = "ppt/GSE221946_feature.pptx")
