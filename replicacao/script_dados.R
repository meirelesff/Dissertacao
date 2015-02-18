# VARIAVEIS PARA O BD PRINCIPAL


library(foreign)
bd <- read.spss("parties.sav", use.value.labels = T, to.data.frame = T)
bd$ano <- as.factor(bd$ano)

# Standardiza os indices

bd$SAEZ_std <- ifelse(is.na(bd$SAEZ_LW), NA, (10 - bd$SAEZ_LW)/2)
bd$PPLA_std <- ifelse(is.na(bd$PPLA_LW), NA, (20 - bd$PPLA_LW)/4)
bd$BAKER_std <- ifelse(is.na(bd$BAKER_LW), NA, (20 - bd$BAKER_LW)/4)

# IDEO1 privilegia os dados do Saez, os do PPLA, os do Coppedge e os atualizados, respectivamente

bd$IDEO1 <- bd$SAEZ_std
bd$IDEO1 <- ifelse(is.na(bd$IDEO1),bd$PPLA_std, bd$IDEO1)
bd$IDEO1 <- ifelse(is.na(bd$IDEO1),bd$COP_LW, bd$IDEO1)
bd$IDEO1 <- ifelse(is.na(bd$IDEO1),bd$COP_LW_Upd, bd$IDEO1)
bd$IDEO1 <- ifelse(is.na(bd$IDEO1), NA, mean(bd$IDEO1, na.rm = T) - bd$IDEO1)

# IDEO2 privilegia os dados do Baker, os do Coppedge e os atualizados

bd$IDEO2 <- bd$BAKER_std
bd$IDEO2 <- ifelse(is.na(bd$IDEO2),bd$PPLA_std, bd$IDEO2)
bd$IDEO2 <- ifelse(is.na(bd$IDEO2),bd$COP_LW, bd$IDEO2)
bd$IDEO2 <- ifelse(is.na(bd$IDEO2),bd$COP_LW_Upd, bd$IDEO2)
bd$IDEO2 <- ifelse(is.na(bd$IDEO2), NA, mean(bd$IDEO2, na.rm = T) - bd$IDEO2)

# IDEO3 usa apenas os dados do Coppedge e os atualizados

bd$IDEO3 <- bd$COP_LW
bd$IDEO3 <- ifelse(is.na(bd$IDEO3),bd$COP_LW_Upd, bd$IDEO3)
bd$IDEO3 <- ifelse(is.na(bd$IDEO3), NA, mean(bd$IDEO3, na.rm = T) - bd$IDEO3)

# Cria versoes ponderadas pelo numero de cadeiras
 
bd$IDEO1_s <- bd$seats*bd$IDEO1
bd$IDEO2_s <- bd$seats*bd$IDEO2
bd$IDEO3_s <- bd$seats*bd$IDEO3

# Cria e armazena as variaveis de dispersao ideologica ponderadas

coals <- aggregate(cbind(IDEO1_s, IDEO2_s, IDEO3_s) ~ country + unica + ano, FUN = sd, na.rm=T, data = bd)
colnames(coals)[4] <- "range1"
colnames(coals)[5] <- "range2"
colnames(coals)[6] <- "range3"
coals <- coals[order(coals$country),]

# Cria e armazena as variaveis de media do congresso

centr <- aggregate(cbind(IDEO1_s, IDEO2_s, IDEO3_s) ~ country + unica + ano, FUN = mean, na.rm=T, data = bd)
colnames(centr)[4] <- "centr1"
colnames(centr)[5] <- "centr2"
colnames(centr)[6] <- "centr3"
centr <- centr[order(centr$country),]

## Funde o bd principal com o centr para calcular o quadrado da distancia entre o presidente e a media do congresso
centr <- merge(bd, centr, by=c("country", "unica", "ano"))

centr$sqrDist1 <- (centr$IDEO1_s - centr$centr1)^2
centr$sqrDist2 <- (centr$IDEO2_s - centr$centr2)^2
centr$sqrDist3 <- (centr$IDEO3_s - centr$centr3)^2

## Reagrega essas distancias para criar o divisor da variavel distance
centrP <- aggregate(cbind(sqrDist1, sqrDist2, sqrDist3) ~ country + unica + ano + president, FUN = sum, na.rm=T, data = centr)
centrP <- centrP[order(centrP$country),]

## Separa os bds com o sem o presidente
centrP <- split(centrP, centrP$president)
centr0 <- centrP[[1]]
centr1 <- centrP[[2]]
colnames(centr1)[5] <- "sqrPres1"
colnames(centr1)[6] <- "sqrPres2"
colnames(centr1)[7] <- "sqrPres3"
colnames(centr0)[5] <- "sqrSum1"
colnames(centr0)[6] <- "sqrSum2"
colnames(centr0)[7] <- "sqrSum3"

centrFinal <- merge(centr0, centr1, by=c("country","unica", "ano"))
centrFinal$distance1 <- centrFinal$sqrPres1 / centrFinal$sqrSum1
centrFinal$distance2 <- centrFinal$sqrPres2 / centrFinal$sqrSum2
centrFinal$distance3 <- centrFinal$sqrPres3 / centrFinal$sqrSum3

coalitions <- merge(coals,centrFinal,by=c("country", "unica", "ano"))
coalitions <- coalitions[,-which(names(coalitions) %in% c("president.x","president.y", "row.names"))]

# Cria as variaiveis para o tamanho da coalizao

cadeiras <- aggregate(seats ~ country + unica + ano + status, FUN = sum, na.rm=T, data = bd)
cadeiras <- subset(cadeiras, status != 0)
colnames(cadeiras)[5] <- "coal.seats"
cadeiras <- merge(cadeiras,bd,by=c("country", "unica", "ano", "status"))
cadeiras$surplus <- ifelse(cadeiras$coal.seats - cadeiras$seats < .5, 0, 1)
cadeiras <- aggregate(cbind(surplus, seats) ~ country + unica + ano, FUN = sum, na.rm=T, data = cadeiras)
colnames(cadeiras)[5] <- "coal.seats"

bd.final <- merge(coalitions, cadeiras, by = c("country", "unica", "ano"))
bd.final$surplusDummy <- ifelse(bd.final$surplus !=0, 1, 0)
bd.final <- bd.final[,-which(names(bd.final) %in% c("sqrSum1","sqrSum2", "sqrSum3", "sqrPres1", "sqrPres2", "sqrPres3"))]

saveRDS(bd.final,"coals.Rda")
write.table(bd.final,"coals.txt", sep="\t")

