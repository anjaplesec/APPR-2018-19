# 4. faza: Analiza podatkov
library(ggplot2)
library(GGally)
library(mgcv)
library(ggpubr)

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


skupaj <- ggarrange(model2, model3, model4, model5, model1)
print(skupaj)
