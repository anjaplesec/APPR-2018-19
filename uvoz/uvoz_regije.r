uvozi.statistične_regije <- function(regije) {
  stolpci <- c("Pomurska", "Podravska", "Koroška", "Savinjska", "Zasavska",
               "Posavksa", "Jugovzhodna Slovenija" , "Jugovzhodna Slovenija",
               "Gorenjska", "Primorsko-notranjska", "Goriška", "Obalno-kraška")
  
  podatki <- read_csv2("podatki/statistične_regije.csv", 
                       col_names=stolpci,
                       locale=locale(encoding="Windows-1250"),
                       skip=1, n_max=15)
  return(podatki)
}

statistične_regije <- uvozi.statistične_regije()
