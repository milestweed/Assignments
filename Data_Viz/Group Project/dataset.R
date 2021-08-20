# library(devtools)
# install_github('iobis/robis')
library(robis)
library(tidyverse)

seaturtles <- occurrence(scientificname = "Chelonioidea")

seaturtles %>% write_csv('seaturtles.csv')
