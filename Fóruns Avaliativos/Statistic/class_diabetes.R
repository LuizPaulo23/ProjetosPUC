#' @title Análise exploratória e modelo de classificação 
#' @author Luiz Paulo T. Gonçalves 

rm(list = ls())
grDevices::graphics.off()

# \Definindo diretório 

setwd("~/Github/Projetos/ProjetosPUC/DBs")

# \Dependências ----------------------------------------------------------------

library(tidyverse)
library(DataExplorer)
library(GGally)
library(rsample)

# Import Dataset ---------------------------------------------------------------

diabetes_raw = utils::read.csv("diabetes.csv") %>% 
               janitor::clean_names()

# Análise exploratória ---------------------------------------------------------

#DataExplorer::plot_intro(diabetes_raw)
DataExplorer::plot_density(diabetes_raw %>% select(-outcome), 
                           title = "Distribuição de Densidade das variáveis analisadas")

DataExplorer::plot_histogram(diabetes_raw %>% select(-outcome), 
                             title = "Distribuição de Frequência das variáveis analisadas")

# Correlação de Pearson 

DataExplorer::plot_correlation(diabetes_raw %>% select(-outcome))

# ggpairs(diabetes_raw %>% select(-outcome),
#         lower = list(continuous = "cor"))

# Visualizando a variável alvo 

plot(table(diabetes_raw$outcome), 
     main = "Balançeamento da variável alvo",
     ylab = "Variável Alvo", 
     col = "red")

# \ATENÇÃO 
# Variável alvo de interesse está desbaloaceada

# Divisão entre treino e teste e Pré processamento -----------------------------

CleanBase <- function(db, transformation, pct_train, var_target){
  
  set.seed(123)
  
  # Divisao entre base de Treino e Teste
  
  data_split <- rsample::initial_split(data = db,
                                       prop = pct_train)
  
  bases <- list(base_train = rsample::training(data_split),
                base_test  = rsample::testing(data_split))
  
  # Pré processando Treino e Teste
  # Loop para aplicar as transformações em treino e teste
  
  for(i in seq_along(bases)) {
    bases[[i]] <- bases[[i]] %>%
      dplyr::select(-dplyr::all_of(var_target)) %>%
      # Imputação pré-definida: mediana *\\
      # Na presença de dados faltantes imputa de forma automática 
      dplyr::mutate_if(is.numeric,
                       zoo::na.aggregate,
                       FUN = median,
                       na.rm = TRUE) %>%
      # Transformação dos dados c("zscore", "minmax", "log", "log+1", "sqrt", "Box-Cox", "Yeo-Johnson")
      dplyr::mutate_if(is.numeric, 
                       ~dlookr::transform(., method = transformation)) %>%
      dplyr::bind_cols(bases[[i]][dplyr::all_of(var_target)]) # %>%
      # Janitor provocando bug na selecão da variável alvo
      # janitor::clean_names()
      # Salvando bases pré-processadas
    switch(names(bases)[i],
           base_train = base_train <- base::data.frame(bases[[i]]),
           base_test = base_test <- base::data.frame(bases[[i]]))
    
  }
  
  return(bases)
  
}


# Chamando a função - CleanBase

db_diabetes = CleanBase(db = diabetes_raw, 
                        transformation = "zscore", 
                        pct_train = 0.85,
                        var_target = "outcome")


# base_train = db_diabetes[["base_train"]] %>% base::as.data.frame()
# base_test = db_diabetes[["base_test"]] %>% base::as.data.frame()

# Algoritmo: k-Nearest Neighbour Classification --------------------------------
# as.data.frame(dplyr::select_if(base_train, function(x) is.numeric(x))
# base_train[, sapply(base_train %>% dplyr::select(-default), is.numeric)]

# Guardando as bases de dados subdivididas em data.frames

var_target = "outcome"

base_train = db_diabetes[["base_train"]] %>% base::as.data.frame()
base_train[[var_target]] <- as.factor(base_train[[var_target]])
base_test = db_diabetes[["base_test"]] %>% base::as.data.frame()
base_test[[var_target]] <- as.factor(base_test[[var_target]])

# Pré-configurado ------------------------------------------------------------
# Criando o controle de treinamento fold CV
ctrl <- caret::trainControl(
                            method = "repeatedcv",
                            number = 10,
                            repeats = 10,
                            verboseIter = TRUE,
                            allowParallel = TRUE,
                            savePredictions = TRUE)

# Grid - Knn -----------------------------------------------------------------

# kn = (nrow(base_train) * 0.01) # Pré-configurado como // 10% do tamanho da amostra
tuneGrid_knn <- expand.grid(k = seq(1, 10, by = 1))
  
  model_knn <- caret::train(as.formula(paste(var_target, "~ .")),
                            data = base_train,
                            method = "knn",
                            trControl = ctrl,
                            #preProcess = c("center", "scale"),
                            tuneGrid = tuneGrid_knn,
                            metric = "Accuracy",
                            maximize = TRUE)
  
  
  