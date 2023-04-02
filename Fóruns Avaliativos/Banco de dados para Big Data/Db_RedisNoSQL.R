#' @title Usando SGBD NoSQL Redis em linguagem R 
#' @author Luiz Paulo T. Gonçalves 
#' @description Busca-se no presente script utilizar o Redis {Adicionar, selecionar e remover dados}

rm(list = ls())

# Packages/Dependências 

library(tidyverse)
library(redux)
library(CliometricsBR)

# Dados para enviar para o banco de dados 
# Dados via pacote CliometricsBR - dados de exportação de açúcar e café 

export_raw <- CliometricsBR::get_seriesIPEA(codes = c("HIST_XACUCARQ",
                                                      "HIST_XCAFEQ"))

# Limpando e organizando o data.frame -------------------------------------------

db_export <- export_raw %>% 
             relocate(date, .after = NULL) %>% 
             pivot_wider(id_cols = date, 
                         names_from = code_series, 
                         values_from = value) %>% 
             clean_names() %>% 
             rename("Açúcar" = "hist_xacucarq", 
                    "Café" = "hist_xcafeq")

# Conectando ao Redis - Cliometrics_Prod ----------------------------------------

redis_conn <- redux::redis_connection(redis_config()) 
print(redis_conn)
r_conex <- redux::hiredis() 

# OPERAÇÃO DE INSERÇÃO NO BANCO DE DADOS REDIS - db_export -------------------------------------

coffe_raw_serialized <- base::serialize(db_export %>% 
                                         select(-"Açúcar"), NULL) 

r_conex$SET("export_cafe", coffe_raw_serialized) # Enviar os dados de café

sugar_raw_serialized <- base::serialize(db_export %>% 
                                          select(-"Café"), NULL)

r_conex$SET("export_acucar", sugar_raw_serialized)  # Enviar os dados de Açúcar

# OPERAÇÃO DE RECUPERAÇÃO/SELEÇÃO ---------------------------------------------------------

check_redis <- function(db = as.character()){
  
  db_export_retrieved <- base::unserialize(r_conex$GET(db))
  db_export_retrieved %>% head()
  
}

# Verificar se os dados foram recuperados corretamente

check_redis("export_acucar")
check_redis("export_cafe")

# OPERAÇÃO DE REMOÇÃO -------------------------------------------------------------------------

r_conex$DEL("export_acucar")

