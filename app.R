# Load necessary packages
library(shiny)
library(g3viz)
library(dplyr)

# Load the dataset
test <- read.csv("test.csv")

# Replace NA values in the 'disease' column with the string "NA"
test$disease[is.na(test$disease)] <- "NA"

# Extract amino acid position from the 'Protein_Change' column
mutation.dat <- test %>%
  mutate(AA_Position = as.numeric(gsub("p\\.[A-Z](\\d+)[A-Z]", "\\1", Protein_Change)))

# Define the user interface
ui <- fluidPage(
  titlePanel("STAT3 Protein Changes"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxInput("allow_multiple", "Allow multiple disease selection", value = FALSE),  # Checkbox for multiple disease selection
      uiOutput("disease_ui"),  # Dynamic UI for disease selection
      fluidRow(
        column(6, downloadButton("download_data", "Download Data")),  # Button to download data
        column(6, actionButton("show_tutorial", "Show Tutorial"))  # Button to show tutorial modal
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", g3LollipopOutput("lollipopPlot", height = "600px")),  # Tab for the plot
        tabPanel("Data", tableOutput("data_table"))  # Tab for the data table
      )
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  
  # Show tutorial modal when the button is clicked
  observeEvent(input$show_tutorial, {
    showModal(modalDialog(
      title = "Tutorial",
      p("Welcome to the STAT3 Protein Changes app"),
      p("This app allows you to explore protein changes across different diseases."),
      p("Use the sidebar to select diseases"),
      p("You can choose multiple diseases if you enable the checkbox."),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Render the UI for disease selection based on the checkbox
  output$disease_ui <- renderUI({
    if (input$allow_multiple) {
      selectizeInput("disease", "Select Disease:", 
                     choices = c("All", unique(test$disease)), 
                     selected = "All",
                     multiple = TRUE,
                     options = list(plugins = list('remove_button')))
    } else {
      selectInput("disease", "Select Disease:", 
                  choices = c("All", unique(test$disease)), 
                  selected = "All",
                  multiple = FALSE)
    }
  })
  
  # Reactive expression to filter data based on selected diseases
  filtered_data <- reactive({
    req(input$disease)
    if ("All" %in% input$disease) {
      mutation.dat
    } else {
      mutation.dat %>% filter(disease %in% input$disease)
    }
  })
  
  # Render the lollipop plot
  output$lollipopPlot <- renderG3Lollipop({
    plot.options <- g3Lollipop.options(
      chart.width = 800,
      chart.type = "pie",
      lollipop.track.height = 400,
      lollipop.track.background = "#F5F5F5",
      lollipop.line.color = "#666666",  # Color for the vertical lines
      lollipop.pop.min.size = 2,
      lollipop.pop.max.size = 10,
      lollipop.color.scheme = "Set1",
      y.axis.label = "# of mutations",
      legend.title = "Disease",
      title.text = "STAT3 Protein Changes",
      title.font = "bold 16px Arial",
      title.color = "#333333"
    )
    
    g3Lollipop(filtered_data(), 
               gene.symbol = "STAT3", 
               gene.symbol.col = "Hugo_Symbol", 
               aa.pos.col = "AA_Position", 
               protein.change.col = "Protein_Change", 
               factor.col = "disease", 
               plot.options = plot.options)
  })
  
  # Render the data table using base R tableOutput
  output$data_table <- renderTable({
    filtered_data()
  })
  
  # Download handler for the data
  output$download_data <- downloadHandler(
    filename = function() {
      paste("stat3_protein_changes_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

# Run the Shiny app
shinyApp(ui = ui, server = server)

# Load the shinylive package
library(shinylive)

# Export the Shiny app using absolute paths
shinylive::export(appdir = file.path("Shiny App"),
                  destdir = "docs")
