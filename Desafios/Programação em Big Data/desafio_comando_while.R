#' @title Desafio comando while
#' @author Luiz Paulo 
#' @description A função calcula a média dos números inteiros digitados diferentes e maiores que zero

dif_zero_while <- function(value = as.vector()){
  
soma <- 0
n <- 0
  
  while (TRUE) {
    
    x <- readline(prompt = "Digite um número (0 para encerrar): ")
    x <- as.numeric(x)
    
  if (x == 0) {
      break
    } else if (x > 0 & !x %in% value) {
      soma <- soma + x
      n <- n + 1
      value <- c(value, x)
    } else {
      next
  }
}
  
  if (n == 0) {
    return("Nenhum número válido foi digitado.")
  } else {
    return(soma/n)
  }

}

dif_zero_while(value = c())

