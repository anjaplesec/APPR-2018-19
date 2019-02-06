# 4. faza: Analiza podatkov
library(ggplot2)
library(GGally)
library(mgcv)

podatki <- tip_gospodinjstva
podatki1 <- drzave %>% filter(drzava == "Slovenia")
zdruzena <- merge(podatki, podatki1, by = "leta")
zdruzena$drzava <- NULL
names(zdruzena)[4] <- "Brezposelnost_v_Sloveniji"
names(zdruzena)[3] <- "Brezposelnost_po_gospodinjstvu"

graf <- ggplot() + 
  geom_point(aes(x=zdruzena$Brezposelnost_v_Sloveniji,
                 y =zdruzena$Brezposelnost_po_gospodinjstvu, 
                 colour= zdruzena$gospodinjstvo, size= zdruzena$leta)) +
  geom_smooth(aes(x= zdruzena$Brezposelnost_v_Sloveniji, 
                  y=zdruzena$Brezposelnost_po_gospodinjstvu), method = "lm") + 
  xlab("Brezposelnost v Sloveniji") + 
  ylab("Brezposelnost po tipu gospodinjstva")

graf <- (graf + labs(colour="leta", size="tip gospodnijstva"))

print(graf)
