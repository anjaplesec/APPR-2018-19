# 4. faza: Analiza podatkov
library(ggplot2)
library(GGally)
library(mgcv)

podatki <- trajanje_brezposelnosti
podatki1 <- drzave %>% filter(drzava == "Slovenia")
zdruzena <- merge(podatki, podatki1, by = "leta")
zdruzena$drzava <- NULL
names(zdruzena)[4] <- "Brezposelnost_v_Sloveniji"
names(zdruzena)[3] <- "brezposelnost_odvisna_od_trajanja_brezposelnosti"

graf <- ggplot() + 
  geom_point(aes(x=zdruzena$brezposelnost_odvisna_od_trajanja_brezposelnosti,
                 y =zdruzena$Brezposelnost_v_Sloveniji, 
                 colour= zdruzena$leta, shape= zdruzena$trajanje)) +
  stat_smooth(aes(x= zdruzena$brezposelnost_odvisna_od_trajanja_brezposelnosti,
                  y=zdruzena$Brezposelnost_v_Sloveniji), method = "lm") + 
  xlab("Brezposelnost po trajanju brezposelnosti") + 
  ylab("Brezposelnost v Sloveniji") 
graf <- (graf + labs(shape="tip gospodinjstva", colour="leta"))

print(graf)

