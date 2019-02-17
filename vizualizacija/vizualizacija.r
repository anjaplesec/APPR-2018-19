# 3. faza: Vizualizacija podatkov
library(rgdal)
library(dplyr)
library(readr)
library(ggplot2)
library(digest)
library(mosaic)


slovenija <- uvozi.zemljevid("https://biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_SVN_shp.zip", 
                             "gadm36_SVN_2", encoding="Windows-1250") %>% 
  fortify()

#gledamo samo leta 2017
regije <- statistične_regije
regije <- as.data.frame(regije, stringAsFactors=FALSE)
regije2017 <- regije[109:120,]

#sprememba imen za regije 
regije2017[3,1] <- "KoroĹˇka"
regije2017[12,1] <- "Obalno-kraĹˇka"
regije2017[11,1] <- "GoriĹˇka"
regije2017[10,1] <- "Notranjsko-kraĹˇka"
regije2017[6,1] <- "Spodnjeposavska"


ggplot(slovenija, aes(x=long, y=lat, group=group, fill=NAME_1)) +
  geom_polygon() +
  labs(title="Slovenija - osnovna slika") +
  theme(legend.position="none")

ggplot() + geom_polygon(data=left_join(slovenija, regije2017, by=c("NAME_1"="regija")),
                        aes(x=long, y=lat, group=group, fill=stopnja)) +
  ggtitle("Stopnja brezposelnosti po statističnih regijah leta 2017") + 
  xlab("") + ylab("") 



# Uvozimo zemljevid Sveta
svet <- uvozi.zemljevid("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries") %>%
  fortify()

#evropa
Evropa <- filter(svet, CONTINENT == "Europe" |NAME == "Turkey")
Evropa <- filter(Evropa, long < 43 & long > -30 & lat > 30 & lat < 73)

drzave <- brezposelnost_drzave
drzave <- as.data.frame(drzave, stringAsFactors=FALSE)
drzave2017 <- drzave[280:310,]
drzave2017[5, 1] <- "Germany"


ggplot(Evropa, aes(x=long, y=lat, group=group, fill=NAME)) +
  geom_polygon() +
  labs(title="svet - osnovna slika") +
  theme(legend.position="none")

ggplot() + geom_polygon(data=left_join(Evropa, drzave2017, by=c("NAME"="drzava")),
                        aes(x=long, y=lat, group=group, fill=stopnja)) +
  ggtitle("Stopnja brezposelnih v Evropi leta 2017") + xlab("") + ylab("")

#grafi
graf_izobrazbe <- ggplot(data = brezposelnost_izobrazba) + 
  aes(x =factor(leta), y = stevilo)+ 
  geom_bar(stat="identity", aes(fill=izobrazba)) + 
  xlab("leta") + 
  ylab("število brezposelnih") +
  ggtitle("Brezposelnost po izobrazbi v Sloveniji")

graf_brezposelnost_spol <- ggplot(data = vsi_brezposelni) +
  aes(x=leta, y=stevilo) +
  geom_bar(stat="identity", aes(fill=spol)) +
  xlab("leta") +
  ylab("število brezposelnih") +
  ggtitle("Brezposelnost po spolu v Sloveniji")


tip_gospodinjstva[c(7,16,25, 34, 43, 52, 61),2] <- "Par ali samohranilec z najmlajšim otrokom starim manj kot \n25 let in drugimi osebami v gospodinjstvu	"
tip_gospodinjstva[c(8, 17, 26, 35, 44, 53, 62),2] <- "Par ali samohranilec z najmlajšim otrokom starim 25 let \nali več in drugimi osebami v gospodinjstvu"

graf_tip_gospodinjstva <- ggplot(data = tip_gospodinjstva, aes(x=leta, y= stopnja, 
                                     colour = gospodinjstvo)) +
  geom_line(size = 1, lineend = "round" ) +
  xlab("leta") +
  ylab("število brezposelnih") +
  ggtitle("Stopnja brezposelnost glede na tip gospodinjstva") + 
  scale_x_continuous(breaks =  seq(2011,2017))

