# IMPORTACAO DE VARIAVEIS PARA O BD PRINCIPAL

library(foreign)
bdal2 <- read.spss("bdal2.sav", use.value.labels = T, to.data.frame = T)

#Carrega o bd do Cheibub, seleciona dele algumas variaveis em transforma os -999 em NA's
ppd <- read.spss("PPD.sav", use.value.labels = T, to.data.frame = T)
ppd1 <- ppd[, which(names(ppd) %in% c("countryname", "year", "bicam", "coalgov", "effveto", "govsh", "presdom"))]
ppd1[ppd1 == -999] <- NA

#Compatibiliza os levels da var. countryname do bd dele
names(ppd1)[1] <- "country"
levels(ppd1$country)
levels(ppd1$country)[8] <- "Argentina"
levels(ppd1$country)[22] <- "Bolivia"
levels(ppd1$country)[25] <- "Brasil"
levels(ppd1$country)[36] <- "Chile"
levels(ppd1$country)[38] <- "Colombia"
levels(ppd1$country)[41] <- "Costa Rica"
levels(ppd1$country)[51] <- "Rep Dominicana"
levels(ppd1$country)[53] <- "Ecuador"
levels(ppd1$country)[55] <- "El Salvador"
levels(ppd1$country)[72] <- "Guatemala"
levels(ppd1$country)[77] <- "Honduras"
levels(ppd1$country)[116] <- "Mexico"
levels(ppd1$country)[127] <- "Nicaragua"
levels(ppd1$country)[135] <- "Panama"
levels(ppd1$country)[138] <- "Peru"
levels(ppd1$country)[137] <- "Paraguai"
levels(ppd1$country)[187] <- "Uruguai"
levels(ppd1$country)[190] <- "Venezuela"
ppd1$year <- as.factor(ppd1$year)

# Funde os dois bancos
bdal3 <- merge(bdal2, ppd1, by=c("country", "year"), all.x = T)

# Importa o QOC

qog <- read.csv("qog.csv", sep=";")
levels(qog$cname)
names(qog)[2] <- "country"
levels(qog$country)[24] <- "Brasil"
levels(qog$country)[52] <- "Rep Dominicana"
levels(qog$country)[143] <- "Paraguai"
levels(qog$country)[198] <- "Uruguai"

qog1 <- qog[, which(names(qog) %in% c("country", 
                                      "year", 
                                      "ciri_injud", 
                                      "fh_status", 
                                      "p_democ", 
                                      "p_xconst",
                                      "al_ethnic",
                                      "dpi_gs",
                                      "dpi_tf",
                                      "dpi_legelec",
                                      "dpi_exelec",
                                      "dpi_pr",
                                      "gol_enpp",
                                      "h_polcon3",
                                      "h_l1",
                                      "wdi_gdpc",
                                      "unna_pop",
                                      "unna_gdp",
                                      "wdi_exp",
                                      "wdi_infl"))]
                                      
bdal4 <- merge(bdal3, qog1, by=c("country", "year"), all.x = T)
saveRDS(bdal4, "bdal4.Rda")

