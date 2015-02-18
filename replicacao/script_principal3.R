# Cria a variavel apoio presidencial

library(foreign)
bd <- read.spss("parties.sav", use.value.labels = T, to.data.frame = T)
bd$ano <- as.factor(bd$ano)

# Agrega a % de cadeiras do presidente e salva num data.frame
coals <- aggregate(seats ~ country + ano + president, FUN = sum, na.rm=T, data = bd)
coals2 <- coals[coals$president == 1,]
coals2 <- coals2[order(coals2$country),]
colnames(coals2)[2] <- "year"
coals2 <- coals2[,-3]


# Carrega o bd versao 5 e cria o polinomio cubico
bdal5 <- read.spss("bdal4.sav", use.value.labels= T, to.data.frame = T)
bdal5$t2 <- (bdal5$t^2)/100
bdal5$t3 <- (bdal5$t^3)/1000

# Adiciona a variavel cadeiras do presidente ao bd5
bdal6 <- merge(bdal5, coals2, by=c("country", "year"), all.x = T)
saveRDS(bdal6,"bdal6.Rda")
write.dta(bdal6, "bdal6.dta")

