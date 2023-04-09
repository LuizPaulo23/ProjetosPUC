#' @title Sistema de Cache com plotagem gráfica implementado em REDIS com linguagem R 
#' @author Luiz Paulo T. Gonçalves 
#' @description Busca-se na presente função construir um sistema de Cache 

CachePlot <- function(db = as.data.frame(), 
                      type = as.character()){
  
# Conectando ao Redis localmente 
  redis_conn <- redux::redis_connection(redis_config()) 
  r_conex <- redux::hiredis() 
  
# Gerando a chave 
key_redis <- paste0("plot_", type, "_", base::deparse(substitute(db)))  

# Verificar se o gráfico já foi plotado anteriormente  
  
  if(r_conex$EXISTS(key_redis) == length(key_redis)){
    # Retorna o plote salvo na key-value
    print(r_conex$PING()) # Para o usuário saber se está conectado ao Redis 
    plot_redis <- base::unserialize(r_conex$GET(key = key_redis))
    cat(key_redis, "Disponível no banco de dados Redis!")
    print(plot_redis)
    
  }else{
    
# Condicional abre caso não tenha o plote no banco de dados 
  
      if(type == "histogram"){
        
        histograma = DataExplorer::plot_histogram(data = db) 
        hist_serialized = base::serialize(histograma, NULL)
        # Guardando no banco de dados 
        print(r_conex$PING())
        r_conex$SET(key = key_redis, hist_serialized)
        cat("Plot", key_redis, "armazenado no Redis com sucesso!")
        
        
      } else if(type == "density"){
        
        density = DataExplorer::plot_density(data = db)
        den_serialized = base::serialize(density, NULL)
        # Guardando no banco de dados 
        print(r_conex$PING())
        r_conex$SET(key = key_redis, den_serialized)
        cat("Plot", key_redis, "armazenado no Redis com sucesso!")
      
      } else{
        
        stop("ERRO: tipo de plote não disponível no sistema de Cache-Redis")
   
          }
        
      }
    
  }
  
