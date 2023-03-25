#' @title Desafio - Estrutura de repetição 
#' @author Luiz Paulo Tavares 
#' @description Função retorna a média utilizando estrutura de repetição 
#' 

rm(list = ls())

cal_mean = function(value = as.vector()) {
  sum = 0
  
  for (i in 1:length(value)) {
    sum = sum + value[i]
 }
  
  mean = sum/length(value)
  return(mean)
  
}

# Testando função 
valores = c(7.0, 8.11)

cal_mean(valores)
mean(valores)


