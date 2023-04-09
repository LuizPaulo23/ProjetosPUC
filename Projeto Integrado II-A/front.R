#' @title Font - Sistema de Cache com plotagem gráfica implementado em REDIS com linguagem R 
#' @author Luiz Paulo T. Gonçalves 
#' @description

front <- function(){

shiny::addResourcePath("www", "www")

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "www/style.css")
  ),
  tags$header(
    id = "header",
    tags$h1("Sistema de Cache com plotagem gráfica implementado em REDIS")
  ),
  sidebarLayout(
    sidebarPanel(
      id = "sidebar",
      selectInput("tipo_plot", "Tipo de Gráfico:", 
                  choices = c("Histograma" = "histogram", "Densidade" = "density")),
      fileInput("dataset", "Selecione o arquivo de dados", accept = c(".csv", ".xlsx")),
      br(),
      actionButton("submit", "Gerar Plot")
    ),
    mainPanel(
      id = "main",
      plotOutput("plot")
    )
  )
)


server <- function(input, output) {
  observeEvent(input$submit, {
    req(input$tipo_plot, input$dataset)
    tipo <- input$tipo_plot
    dados <- readxl::read_excel(input$dataset$datapath)
    plot <- CachePlot(dados, tipo)
    output$plot <- renderPlot(plot)
  })
}

shinyApp(ui = ui, server = server)

}


