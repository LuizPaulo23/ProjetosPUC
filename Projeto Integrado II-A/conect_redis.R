#install.packages("redux", dependencies = T)
library(redux)

rm(list = ls())

redis_conex = redux::redis_connection(redis_config()) 
redis <- redux::hiredis() 


redis_conex$SET("154", "1254") # set the key "mykey" to the value "mydata"
