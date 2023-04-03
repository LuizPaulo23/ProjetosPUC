# Carregar pacotes necessários
library(RSQLite)
library(ggplot2)

# Conectar ao banco de dados SQLite
conn <- dbConnect(RSQLite::SQLite(), dbname = "myplot.db")

# Criar tabela para armazenar gráficos
dbExecute(conn, "CREATE TABLE IF NOT EXISTS plots (plot_id TEXT PRIMARY KEY, plot BLOB)")

# Definição da função para plotar o gráfico
myplot <- function(data, plot_type) {

  # Identificador único para o conjunto de dados de entrada e tipo de gráfico
  plot_id <- paste0(names(data), plot_type)

  # Verificar se o gráfico já foi plotado anteriormente
  query <- paste0("SELECT plot FROM plots WHERE plot_id = '", plot_id, "'")
  plot_data <- dbGetQuery(conn, query)

  # Caso o gráfico não exista no cache
  if(nrow(plot_data) == 0) {
    plot_data <- list(plot_id = plot_id, plot = ggplot(data, aes(x = Sepal.Length, y = Sepal.Width)) +
                        geom_point(aes(color = Species)) +
                        ggtitle(paste0(plot_type, " plot")))
    # Inserir o novo gráfico no cache
    dbExecute(conn, "INSERT INTO plots (plot_id, plot) VALUES (?, ?)", plot_id, serialize(plot_data$plot, NULL))
  } else {
    # Recuperar o gráfico do cache
    plot_data <- unserialize(plot_data$plot[1])
  }

  # Retornar o gráfico
  plot_data
}


