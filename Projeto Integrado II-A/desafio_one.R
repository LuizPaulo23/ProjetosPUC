rm(list = ls())

library(tidyverse)
library(knitr)

# converta -> polegada = 2,54cm e 1 libra = 0,45kg.

data_raw = datasets::women %>% 
           dplyr::mutate(altura = (height * 2.54), 
                         peso = (weight * 0.45)) %>% 
                 group_by() %>% 
                 summarise(media_polegadas = mean(height, na.rm = T), 
                           desvio_polegadas = sd(height, na.rm = T), 
                           media_libra = mean(weight, na.rm = T), 
                           desvio_libra = sd(weight, na.rm = T), 
                           # Média e o desvio padrão para os valores convertidos
                           media_cm = mean(altura, na.rm = T), 
                           media_kg = mean(peso, na.rm = T)) %>% kable() %>% print()
