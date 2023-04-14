# Debugging - Latex 
# If an error occurs when compiling a LaTeX to PDF, and the error message is not clear, 
# please follow these steps one by one until the problem is gone.
# https://yihui.org/tinytex/r/

# install.packages('tinytex')
# tinytex::install_tinytex()

update.packages(ask = F, checkBuilt = T)
tinytex::tlmgr_update()