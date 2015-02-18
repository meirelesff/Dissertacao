# BANCO PRINCIPAL

#Carrega o banco no formato pais-ano e ajusta o tipo das variaveis

library(foreign)
bdal <- read.spss("bdal.sav", use.value.labels = T, to.data.frame = T)
bdal$id <- as.factor(bdal$id)
bdal$year <- as.factor(bdal$year)
bdal$exect <- as.factor(bdal$exect)
bdal$crisis <- ifelse(bdal$crisis == "Yes", 1, ifelse(is.na(bdal$crisis), NA, 0))
                      
levels(bdal$country)
levels(bdal$country)[7] <- "Rep Dominicana"
levels(bdal$country)[8] <- "Ecuador"
levels(bdal$country)[11] <- "Mexico"
levels(bdal$country)[12] <- "Nicaragua"
levels(bdal$country)[13] <- "Panama"

# Funde o banco das coalizoes com este

names(bd.final)[3] <- "year"
bdal <- merge(bdal, bd.final, by=c("country", "year"), all = T)
saveRDS(bdal,"bdal.Rda")

