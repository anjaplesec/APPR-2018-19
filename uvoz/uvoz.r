# 2. faza - UVOZ PODATKOV

sl <- locale("sl", decimal_mark=",", grouping_mark=".")
source("lib/libraries.r", encoding="UTF-8")
library(tidyr)
library(readxl)
library(data.table)
library(dplyr)
library(readr)
library(ggplot2)
library(abind)

#uvoz brezposelnosti izobrazba
uvozi.brezposelnost_izo <- function(izobrazba) {
  stolpci <- c("regija", "x", "leta", "Brez izobrazbe", "Osnovnosolska", 
               "Nizja ali srednja poklicna", "Srednja strokovna, splosna" , 
               "Visjesolska, visokosolska")
  podatki <- read_csv2("podatki/izobrazba.csv", 
                       col_names=stolpci,
                       locale=locale(encoding="Windows-1250"),
                       skip=7, n_max=10) %>% .[, -(1:2)] %>%
    melt(id.vars= "leta",  variable.name="izobrazba", value.name="stevilo") %>%
    mutate(stevilo=parse_number(stevilo, na="N"))
}
brezposelnost_izobrazba <- uvozi.brezposelnost_izo()



#uvoz brezposelnosti
uvozi.brezposelni <- function(ljudje) {
  stolpci <- c("j", "p","spol", 2008:2017)
  podatki <- read_csv2("podatki/brezposelni.csv", 
                       col_names=stolpci,
                       locale=locale(encoding="Windows-1250"),
                       skip=6, n_max=2) %>% .[, -(1:2)] %>% 
    melt(id.vars="spol", variable.name="leta", value.name="stevilo")
}

vsi_brezposelni <- uvozi.brezposelni()

#uvoz brezposelnosti glede na trajanje brezposelnosti
uvozi.trajanje_brezposelnosti <- function(trajanje) {
  stolpci <- c("l", "spol", "p", "t", "r", "trajanje", 2008:2017)
  podatki <- read_csv2("podatki/trajanje_brezposelnosti.csv", 
                       col_names=stolpci,
                       locale=locale(encoding="Windows-1250"),
                       skip=7, n_max=5) %>% .[, -(5:1)] %>%
    melt(id.vars="trajanje", variable.name="leta", value.name="stevilo")
}
trajanje_iskanje_dela <- uvozi.trajanje_brezposelnosti()


#uvoz brezposelnosti glede na tip gospodinjstva
uvozi.tip_gospodinjstva <- function(gopodinjstvo) {
  stolpci <- c("regija", "leta", "gospodinjstvo", "stopnja")
  podatki <- read_csv2("podatki/gospodinjstvo.csv", 
                       col_names=stolpci,
                       locale=locale(encoding="Windows-1250"),
                       skip=5, n_max=70) %>% .[, -1] %>%
    melt(id.vars=c("leta", "gospodinjstvo"), variable.name="regija",
         value.name="stopnja") %>%
    fill(1) %>% drop_na(2) %>% mutate(stopnja = parse_number(stopnja))
}
tip_gospodinjstva <- uvozi.tip_gospodinjstva()
tip_gospodinjstva$regija <- NULL

#uvoz brezposelnosti glede na statistične regije
uvozi.statistične_regije <- function(regije) {
  stolpci <- c("regija", 2008:2017)
  podatki <- read_csv2("podatki/statisticne_regije.csv", 
                       col_names=stolpci,
                       locale=locale(encoding="Windows-1250"),
                       skip=4, n_max=12) %>%
    melt(id.vars="regija", variable.name="leta", value.name="stopnja")  %>%
    mutate(stopnja = parse_number(stopnja))
}

statistične_regije <- uvozi.statistične_regije()



#uvoz brezposelnosti glede na države
uvozi.brezposelnost_drzave <- function(drzava) {
  stolpci <- c("drzava", 2008:2017)
  podatki <- read_csv2("podatki/drzave.csv", 
                       col_names=stolpci,
                       locale=locale(encoding="Windows-1250"),
                       skip=11, n_max=31) %>%
    melt(id.vars="drzava", variable.name="leta", value.name="stopnja")
}

brezposelnost_drzave <- uvozi.brezposelnost_drzave()

#uvoz brazposelnosti za 4. fazo
uvozi.4faza <- function(faza) {
  stolpci <- c("država", "obcina", 2005:2016)
  podatki <- read_csv2("podatki/4_faza.csv", 
                       col_names=stolpci,
                       locale=locale(encoding="Windows-1250"),
                       skip=6, n_max=212) %>% .[, -(1:1)] %>% 
    melt(id.vars="obcina", variable.name="leta", value.name="stevilo") %>%
    mutate(stevilo=parse_number(stevilo, na="N"))
}

obcine <- uvozi.4faza()

