#' @title Desafio - Estrutura Condicional 
#' @author Luiz Paulo Tavares 
#' @description Função retorna a média ponderada quando os vetores tem o mesmo tamanho 

rm(list = ls()) # limpando a memória 
library(stats) # package 


mean_weighted <- function(value = as.vector(), 
                          weight = as.vector()){
  
  
  if(length(value) == length(weight)){
    
    mean_weighted = stats::weighted.mean(value, weight)
    cat("Média ponderada:", mean_weighted)
    
  }else{
    print(NULL)
    stop("ERRO: vetores de tamanho diferente")
    
  }
  
}

# Testando a função ------------------------------------------

valores = c(7.0, 8.11)
pesos = c(3.0, 2.0)

mean_weighted(value = valores, weight = pesos)

# Validanado se os valores estão corretas: 

numerador = sum(valores * pesos) |> print()
denominador = sum(pesos) |> print()

media_ponderada = (numerador/denominador) |> print()






