# 3. faza: Vizualizacija podatkov
library(rgdal)
library(dplyr)
library(readr)
library(ggplot2)
library(digest)
library(mosaic)


slovenija <- uvozi.zemljevid("https://biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_SVN_shp.zip", 
                             "gadm36_SVN_2") %>% 
  fortify()

#gledamo samo leta 2017
regije <- statistične_regije
regije <- as.data.frame(regije, stringAsFactors=FALSE)
regije2017 <- regije[109:120,]

#sprememba imen za regije 
regije2017[3,1] <- "Koroška"
regije2017[12,1] <- "Obalno-kraška"
regije2017[11,1] <- "Goriška"
regije2017[10,1] <- "Notranjsko-kraška"
regije2017[6,1] <- "Spodnjeposavska"


ggplot(slovenija, aes(x=long, y=lat, group=group, fill=NAME_1)) +
  geom_polygon() +
  labs(title="Slovenija - osnovna slika") +
  theme(legend.position="none")

ggplot() + geom_polygon(data=left_join(slovenija, regije2017, by=c("NAME_1"="regija")),
                        aes(x=long, y=lat, group=group, fill=stevilo)) +
  ggtitle("Število brezposelnih na 1000 ljudi leta 2017") + xlab("") + ylab("") 



# Uvozimo zemljevid Sveta
svet <- uvozi.zemljevid("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries") %>%
  fortify()

#evropa
Evropa <- filter(svet, CONTINENT == "Europe" |NAME == "Turkey")
Evropa <- filter(Evropa, long < 43 & long > -30 & lat > 30 & lat < 73)

drzave <- brezposelnost_drzave
drzave <- as.data.frame(drzave, stringAsFactors=FALSE)
drzave2017 <- drzave[307:340,]
drzave2017[6, 1] <- "Germany"


ggplot(Evropa, aes(x=long, y=lat, group=group, fill=NAME)) +
  geom_polygon() +
  labs(title="svet - osnovna slika") +
  theme(legend.position="none")

ggplot() + geom_polygon(data=left_join(Evropa, drzave2017, by=c("NAME"="drzava")),
                        aes(x=long, y=lat, group=group, fill=(stevilo)),
                        colour = "black") +
  ggtitle("Število brezposelnih v Evropi leta 2017") + xlab("") + ylab("") 

#grafi
graf_izobrazbe <- ggplot(data = brezposelnost_izo) + 
  aes(x =factor(leta), y = stevilo)+ 
  geom_bar(stat="identity", aes(fill=izobrazba)) + 
  xlab("leta") + 
  ylab("število brezposelnih") +
  ggtitle("Brezposelnost po izobrazbi")

graf_brezposelnost_spol <- ggplot(data = brezposelni) +
  aes(x=leta, y=stevilo) +
  geom_bar(stat="identity", aes(fill=spol)) +
  xlab("leta") +
  ylab("�tevilo brezposelnih") +
  ggtitle("Brezposelnost po spolu")

graf_tip_gospodinjstva <- ggplot(data = tip_gospodinjstva, aes(x=leta, y= stevilo, 
                                     colour = gospodinjstvo)) +
  geom_line(size = 1, lineend = "round" ) +
  xlab("leta") +
  ylab("število brezposelnih") +
  ggtitle("Brezposelnost glede na tip gospodinjstva")



