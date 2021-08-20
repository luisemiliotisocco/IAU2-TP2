#----------------------------------------
#SCRAPPING

library(tidyverse) # Easily Install and Load the 'Tidyverse'
library(rvest) # Easily Harvest (Scrape) Web Pages
library(stringr) # Simple, Consistent Wrappers for Common String Operations


#COTIZACIÓN DEL DÓLAR

url <- "https://www.cronista.com/MercadosOnline/dolar.html" #cargo la URL


#importo la tabla por columna

moneda <- read_html(url) %>%
  html_nodes(xpath = '//*[(@id = "market-scrll-1")]//*[contains(concat( " ", @class, " " ), concat( " ", "name", " " ))]') %>%
  html_text2()

  variacion <- read_html(url) %>% 
  html_nodes(xpath = '//*[(@id = "market-scrll-1")]//*[contains(concat( " ", @class, " " ), concat( " ", "percentage", " " ))]') %>%
  html_text() %>% 
  str_replace_all("[^[:alnum:]]", "") %>% #elimino caracteres que no sean alfanuméticos 
  as.numeric()

valor <- read_html(url) %>% 
  html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "value", " " ))]') %>%
  html_text() %>%
  str_replace_all ("[^[:alnum:]]", "") %>% #elimino caracteres que no sean alfanuméticos 
  as.numeric()

#uno las columnas en una tabla
tabla <- tibble(
  moneda = moneda,
  variacion=variacion, 
  valor= valor)

cotizacion <- tabla %>% 
  slice(2:nrow(tabla)) %>% #elimino primera fila que trae el nombre de las columnas
  mutate(variacion=variacion/100) %>%  #agrego los decimales que eliminé anteriormente
  mutate(valor=valor/100)

str (cotizacion) #compruebo la estructura de los datos. Todos los valores (experto el nombre de la moneda) son numéricos

# Logré scrapperar una tabla con la cotización actualizada del dólar que voy a reciclar en el siguiente ejercicio
# A continuación la guardo: 

write.csv(cotizacion, "data/cotizacion.csv")