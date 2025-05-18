library(shiny)
library(DT)
library(DBI)
library(RSQLite)
library(dplyr)

ui <- fluidPage(
  tags$style(HTML("
    .inline-label-input {
      display: inline-block;
      vertical-align: bottom;
      margin-right: 10px;
    }
    .inline-label-input label {
      display: inline-block;
      margin-right: 5px;
      font-weight: bold;
    }
    .inline-label-input input {
      display: inline-block;
      height: 40px;
      font-size: 14px;
    }
  ")),
  
  fluidRow(
    div(
      style = "display: flex; align-items: center; gap: 10px;",
    div(column(3, textInput("keyword", "Keyword: ")%>%
                  tagAppendAttributes(class = "uniform-input"))),
    div(column(3, selectInput("species", "Species: ",
              choices = c("all", "HS", "MM", "RN", "RM", "DR"),
              selected = "all")%>%
                tagAppendAttributes(class = "uniform-input"))),
    div(column(3, selectInput("collection", "Collection: ",
              choices = c("all", "C2:CGP", "C1", "C2:CP:BIOCARTA", "C2:CP:KEGG_LEGACY", "C3:MIR:MIRDB", "C3:MIR:MIR_LEGACY", "C3:TFT:GTRD", "C3:TFT:TFT_LEGACY", "C2:CP:REACTOME", "C2:CP:WIKIPATHWAYS", "C2:CP", "C4:CGN", "C4:CM", "C6", "C4:3CA", "C7:IMMUNESIGDB", "C7:VAX", "C8", "C5:GO:BP", "C5:GO:CC", "C5:GO:MF", "H", "C5:HPO", "C2:CP:KEGG_MEDICUS"),
              selected = "all")%>%
                tagAppendAttributes(class = "uniform-input"))),
    div(column(3, actionButton("moreinfo", "More Info"))%>%
          tagAppendAttributes(class = "uniform-button")))),
  
  fluidRow(
    column(12, DTOutput("Hu.Msigdf.filtered")))
)




server <- function(input, output, session) {
  Hu.Msigdf <- read.csv("https://raw.githubusercontent.com/HonglabKNU/Main/refs/heads/CS/DB/msigdb_v2024.1.Hs.csv")
  Hu.Msigdf <- Hu.Msigdf[, -1]
  
  #filtering by keyword
  Hu.Msigdf.filtered <- reactive({
    filtered.data <- Hu.Msigdf %>% select(1:3, "source_species_code")
    if (input$keyword != "" && !is.null(input$keyword)) {
      keyword <- tolower(input$keyword)
      filtered.data <- Hu.Msigdf %>%
        filter(if_any(c("standard_name", "description_brief", "description_full"), ~ grepl(keyword, ., ignore.case = TRUE))) %>%
        select(1:3, "source_species_code")
    }
    
    if (input$species != "all") {
      filtered.data <- filtered.data %>% filter(source_species_code == input$species)
    }
    
    if (input$collection != "all") {
      filtered.data <- filtered.data %>% filter(collection_name == input$collection)
    }
    
    return(filtered.data)
  })
  
  output$Hu.Msigdf.filtered <- renderDT({
    datatable(Hu.Msigdf.filtered(), selection = "single", 
              rownames = F
    )
  })
  
  #open detail url
  observeEvent(input$moreinfo, {
    geneset.selected <- input$Hu.Msigdf.filtered_rows_selected
    if(length(geneset.selected) == 1) {
      geneset.selected.id <- Hu.Msigdf.filtered()$standard_name[geneset.selected]
      
      geneset.selected.keyword <- ifelse(is.null(input$keyword), "", input$keyword)
      
      url <- paste0("https://www.gsea-msigdb.org/gsea/msigdb/human/geneset/",
                    geneset.selected.id, 
                    ".html?keywords=",
                    geneset.selected.keyword)
      
      browseURL(url)
    } else {}
  })

}

shinyApp(ui, server)
