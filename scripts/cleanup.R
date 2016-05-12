require(reshape)
require(lubridate)

dfrawEmails <- read.csv('data/emails.csv', head=T, as.is=TRUE)
dfEmails <- dfrawEmails

# Do the sender mapping here? 
# If we add/change the mapping file, this needs to be a part of the code.

dfDates <- dfEmails[,c("Date","Year")]
dfEmails$Date <- as.Date(apply(dfDates, 1, function(x) paste0(x[1],"-",x[2])), format="%d-%b-%Y")
dfEmails$Year <- NULL


dfEmails$DD <- day(dfEmails$Date)
dfEmails$MM <- month(dfEmails$Date)
dfEmails$YYYY <- year(dfEmails$Date)

dfEmails$hh <- sapply(strsplit(dfEmails$Time,":"), "[[", 1)
dfEmails$mm <- sapply(strsplit(dfEmails$Time,":"), "[[", 2)
dfEmails$ss <- sapply(strsplit(dfEmails$Time,":"), "[[", 3)



dfL12mapping <- read.csv('data/level1to2.csv', as.is=TRUE)
dfEmails2 <- merge(dfEmails, dfL12mapping,by.x = "SenderMapped", by.y = "Level1")

write.csv(dfEmails2,file = "data/emaildatacleaned.csv",quote = T,row.names = F)











