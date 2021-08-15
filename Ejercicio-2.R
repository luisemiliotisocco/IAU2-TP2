#----------------------------------------
#SCRAPPING

library(tidyverse) # Easily Install and Load the 'Tidyverse'
library(rvest) # Easily Harvest (Scrape) Web Pages
library(stringr) # Simple, Consistent Wrappers for Common String Operations


#COTIZACIÓN DEL DÓLAR

url <- "https://www.cronista.com/MercadosOnline/dolar.html" #cargo la URL


#importo la tabla por columna

moneda <- read_html(url) %>%
  html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "name", " " )) and contains(concat( " ", @class, " " ), concat( " ", "col", " " ))]
') %>%
  html_text2()

variacion <- read_html(url) %>% 
  html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "percentage", " " )) and contains(concat( " ", @class, " " ), concat( " ", "col", " " ))]
') %>%
  html_text() %>% 
  str_replace_all("[^[:alnum:]]", "") %>% #elimino caracteres que no sean alfanuméticos 
  as.numeric()

compra <- read_html(url) %>% 
  html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "buy", " " )) and contains(concat( " ", @class, " " ), concat( " ", "col", " " ))]') %>%
  html_text() %>% 
  substring(8) %>% #elimino el string "Compra$"
  str_replace_all("[^[:alnum:]]", "") %>% #elimino caracteres que no sean alfanuméticos 
  as.numeric()

venta <- read_html(url) %>% 
  html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "sell", " " )) and contains(concat( " ", @class, " " ), concat( " ", "col", " " ))]') %>%
  html_text() %>% 
  str_replace_all("[^[:alnum:]]", "") %>% #elimino caracteres que no sean alfanuméticos 
  as.numeric()

#uno las columnas en una tabla
tabla <- tibble(
  moneda = moneda, 
  variacion = variacion, 
  compra = compra,
  venta= venta
)

cotizacion <- tabla %>% 
  slice(2:nrow(tabla)) %>% #elimino primera fila que trae el nombre de las columnas
  mutate(variacion=variacion/100) %>%  #agrego los decimales que eliminé anteriormente
  mutate(compra=compra/100) %>% 
  mutate(venta=venta/100)

str (cotizacion) #compruebo la estructura de los datos. Todos los valores (experto el nombre de la moneda) son numéricos

# Logré scrapperar una tabla con la cotización actualizada del dólar que voy a reciclar en el siguiente ejercicio
# A continuación la guardo: 

write.csv(cotizacion, "data/cotizacion.csv")
