
uvozi.brezposelnost_izo <- function(izobrazba) {
  stolpci <- c("regija", "spol", "leto", "Brez izobrazbe", "Osnovnošolska", "Nižja ali srednja poklicna", 
               "Srednja strokovna, splošna" , "Višješolska, visokošolska")
  podatki <- read_csv2("podatki/brazposelnost_izo.csv", 
                    col_names=stolpci,
                    locale=locale(encoding="Windows-1250"),
                    skip=7, n_max=10) %>% .[, -(1:2)] %>%
    mutate(`Brez izobrazbe`=parse_number(`Brez izobrazbe`)) %>%
    melt(id.vars="leto", variable.name="izobrazba", value.name="stevilo")
  return(podatki)
}

brezposelnost_izo <- uvozi.brezposelnost_izo()
