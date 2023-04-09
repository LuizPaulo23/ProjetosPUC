#' @title TESTANDO- Sistema de Cache com plotagem gráfica implementado em REDIS com linguagem R 
#' @author Luiz Paulo T. Gonçalves 

# Deletando tudo que está no Redis 
# Testar em ambiente limpo ---------------------------------------
redis_conn <- redux::redis_connection(redis_config()) 
r_conex <- redux::hiredis() 
r_conex$DEL(r_conex$KEYS("*")) 

# Dados usandos no teste -------------------------------------------
db_iris = iris
# writexl::write_xlsx(db_iris, "DB_iris.xlsx")

# Tipos possíveis disponíveis 
# type = c("histogram", "density")

# \\TESTES ---------------------------------------------------------

CachePlot(db = iris, 
          type = "density") 

CachePlot(db = iris, 
          type = "histogram") 


# VERIFICANDO EXISTÊNCIA DE BUG 

CachePlot(db = iris, 
          type = "dfsdfsdfs") 

# LOG: OKAY 
# FUNÇÃO NÃO ACEITA TYPE FORA DO DECLARADO COMO ESPERADO 

