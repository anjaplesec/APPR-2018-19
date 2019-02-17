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
                        aes(x=long, y=lat, group=group, fill=stopnja),
                        colour = "black") +
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

graf_tip_gospodinjstva <- ggplot(data = tip_gospodinjstva, aes(x=leta, y= stopnja, 
                                     colour = gospodinjstvo)) +
  geom_line(size = 1, lineend = "round" ) +
  xlab("leta") +
  ylab("število brezposelnih") +
  ggtitle("Stopnja brezposelnost glede na tip gospodinjstva")

# 4. faza: Analiza podatkov
library(ggplot2)
library(GGally)
library(mgcv)

#NAPOVED BREZPOSELNOSTI VISJESOLSKA
tabela.preciscena1 <- brezposelnost_izobrazba %>% filter(izobrazba =="Visjesolska, visokosolska")
tabela.preciscena1$izobrazba <- NULL
star <- lm(data=tabela.preciscena1, stevilo ~ leta)

model1 <- ggplot(tabela.preciscena1) + 
  aes(x=leta, y=stevilo) + 
  ylab("število brezposelnih") +
  geom_point(size = 3) + 
  ggtitle("višješolska ali visokošolska \nizobrazba") +
  theme(plot.title = element_text(size = 10, face = "bold", hjust=0.5))+
  geom_smooth(method="lm", formula = y ~ x, fullrange = TRUE, se = FALSE) 
novi.podatki1 <- data.frame(leta = seq(2018, 2022))
napoved1 <- novi.podatki1 %>% mutate(stevilo=predict(star, .))
model1 <- model1 + geom_point(data=napoved1, aes(x=leta, y=stevilo), color="red", size=3) + 
  scale_x_continuous(breaks = seq(2008,2022, 3))

#BREZ IZOBRAZBE 
tabela.preciscena2 <- brezposelnost_izobrazba %>% filter(izobrazba =="Brez izobrazbe")
tabela.preciscena2$izobrazba <- NULL
star2 <- lm(data=tabela.preciscena2, stevilo ~ leta)

model2 <- ggplot(tabela.preciscena2) + 
  aes(x=leta, y=stevilo) + 
  ylab("število brezposelnih") +
  geom_point(size = 3) + 
  ggtitle("brez izobrazbe") +
  theme(plot.title = element_text(size = 10, face = "bold", hjust=0.5))+
  geom_smooth(method="lm", formula = y ~ x, fullrange = TRUE, se = FALSE)
novi.podatki2 <- data.frame(leta = seq(2018, 2022, 1))
napoved2 <- novi.podatki2 %>% mutate(stevilo=predict(star2, .))
model2 <- model2 + geom_point(data=napoved2, aes(x=leta, y=stevilo), color="red", size=3) +
  scale_x_continuous(breaks =  seq(2008,2022, 3)) + scale_y_continuous(breaks = 0:2)

#OSNOVNOSOLSKA
tabela.preciscena3 <- brezposelnost_izobrazba %>% filter(izobrazba =="Osnovnosolska")
tabela.preciscena3$izobrazba <- NULL
star3 <- lm(data=tabela.preciscena3, stevilo ~ leta)

model3 <- ggplot(tabela.preciscena3) + 
  aes(x=leta, y=stevilo) + 
  ylab("število brezposelnih") +
  theme(plot.title = element_text(size = 10, face = "bold", hjust=0.5))+
  geom_point(size = 3) + 
  ggtitle("osnovnošolska \nizobrazba") +
  geom_smooth(method="lm", formula = y ~ x, fullrange = TRUE, se = FALSE)
novi.podatki3 <- data.frame(leta = seq(2018, 2022, 1))
napoved3 <- novi.podatki3 %>% mutate(stevilo=predict(star3, .))
model3 <- model3 + geom_point(data=napoved3, aes(x=leta, y=stevilo), color="red", size=3) +
  scale_x_continuous(breaks =  seq(2008,2022, 3)) + scale_y_continuous(7:20)

#NIZJA ALI SREDNJA POKLICNA
tabela.preciscena4 <- brezposelnost_izobrazba %>% filter(izobrazba =="Nizja ali srednja poklicna")
tabela.preciscena4$izobrazba <- NULL
star4 <- lm(data=tabela.preciscena4, stevilo ~ leta)

model4 <- ggplot(tabela.preciscena4) + 
  aes(x=leta, y=stevilo) + 
  ylab("število brezposelnih") +
  geom_point(size = 3) + 
  ggtitle("nižja ali srednja \npoklicna izobrazba") + 
  theme(plot.title = element_text(size = 10, face = "bold", hjust=0.5))+
  geom_smooth(method="lm", formula = y ~ x, fullrange = TRUE, se = FALSE) 
novi.podatki4 <- data.frame(leta = seq(2018, 2022, 1))
napoved4 <- novi.podatki4 %>% mutate(stevilo=predict(star4, .))
model4 <- model4 + geom_point(data=napoved4, aes(x=leta, y=stevilo), color="red", size=3) +
  scale_x_continuous(breaks =  seq(2008,2022, 3))


#SREDNJA STROKOVNA, SPOLOSNA
tabela.preciscena5 <- brezposelnost_izobrazba %>% filter(izobrazba =="Srednja strokovna, splosna")
tabela.preciscena5$izobrazba <- NULL
star5 <- lm(data=tabela.preciscena5, stevilo ~ leta)

model5 <- ggplot(tabela.preciscena5) + 
  aes(x=leta, y=stevilo) + 
  ylab("število brezposelnih") +
  theme(plot.title = element_text(size = 10, face = "bold", hjust=0.5))+
  geom_point(size = 3) + 
  ggtitle("srednja strokovna ali \nsplošna izobrazba") +
  geom_smooth(method="lm", formula = y ~ x, fullrange = TRUE, se = FALSE)
novi.podatki5 <- data.frame(leta = seq(2018, 2022, 1))
napoved5 <- novi.podatki5 %>% mutate(stevilo=predict(star5, .))
model5 <- model5 + geom_point(data=napoved5, aes(x=leta, y=stevilo), color="red", size=3) +
  scale_x_continuous(breaks =  seq(2008,2022, 3))


skupaj <- ggarrange(model2, model3, model4, model5, model1, common.legend = TRUE, 
                    legend = "bottom", warning = FALSE)

