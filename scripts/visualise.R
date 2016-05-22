require(reshape)
require(ggplot2)
require(scales)


load("data//emaildatacleaned.RData") #dfEmails

cols <- names(dfEmails)
dfEmails <- data.frame(dfEmails,weekdays(as.Date(dfEmails$Date)))
names(dfEmails) <- c(cols,"Day")
dfYearlyTotals <- with(dfEmails, aggregate(Subject, by=list(Year = YYYY, By = Category), FUN=length))

ggYearly <- ggplot(dfYearlyTotals[dfYearlyTotals$Year<2016,], aes(x = Year,
                                       y = x, #automatic variable name in aggregate
                                       color= By)
                   )
ggYearly + geom_line()

ggsave(file="VariationAcrossYears.jpeg")

# Days of the Year

dfDaysoftheYear <- with(dfEmails[dfEmails$YYYY<2016,], aggregate(Subject, by=list(Month = MM, Day = DD), FUN=length))
ggDaysoftheYear <- ggplot(dfDaysoftheYear, aes(y = as.Date(paste0("2000-",Month,"-01")),
                                               x = Day,
                                               alpha = x/max(dfDaysoftheYear$x))
                          )

ggDaysoftheYear + geom_point(colour = "#0077BB", size = 10, shape = 15) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        #axis.text.y = element_text(vjust=-2),
        legend.position="none") +
  scale_x_discrete(breaks=1:31) + 
  scale_y_date(breaks = date_breaks("1 month"),
               limits = c(as.Date("2000-01-01", format="%Y-%m-%d"), as.Date("2000-12-01", format="%d-%m-%Y")),
               labels = date_format("%b"))

ggsave(file="DaysOfTheYear.jpeg")

# Time of the Day Everyone
dfTimeoftheDay <- with(dfEmails[dfEmails$SenderMapped!="Mailman",], aggregate(Subject, by=list(hh=hh, mm=mm), FUN=length))  # Removing Mailman which is skewing the graph to 6am
 

start <- ISOdate(2001, 1, 1, hour=0, tz = "")
ggDaysoftheYear <- ggplot(dfTimeoftheDay, aes(x = start+60*(60*hh + mm),
                                              y=0,
                                              alpha = x/max(dfTimeoftheDay$x))
                          )

ggDaysoftheYear + geom_tile() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(), 
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(), 
        axis.ticks.x = element_blank(), 
        axis.text.y = element_blank(),
        panel.background = element_rect(fill = "white"),
        legend.position="none")  +
  scale_y_continuous(expand = c(0.01,0)) +
  scale_x_datetime(breaks = date_breaks("1 hour"),
                   limits = c(ISOdate(2001, 1, 1, hour=1, tz = ""), ISOdate(2001, 1, 1, hour=23, tz = "")),
                   labels = date_format("%H"))

ggsave(file="TimeOfTheDay.jpeg")

# Time of the Day Students
dfEmailsStudents <- dfEmails[dfEmails$Category=="Student Reps",]
dfTimeoftheDay <- with(dfEmailsStudents, aggregate(Subject, by=list(hh=hh, mm=mm), FUN=length))

start <- ISOdate(2001, 1, 1, hour=0, tz = "")
ggDaysoftheYear <- ggplot(dfTimeoftheDay, aes(x = start+60*(60*hh + mm),
                                              y=0,
                                              alpha = x/max(dfTimeoftheDay$x))
                          )

ggDaysoftheYear + geom_tile() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(), 
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(), 
        axis.ticks.x = element_blank(), 
        axis.text.y = element_blank(),
        panel.background = element_rect(fill = "white"),
        legend.position="none")  +
  scale_y_continuous(expand = c(0.01,0)) +
  scale_x_datetime(breaks = date_breaks("1 hour"),
                   limits = c(ISOdate(2001, 1, 1, hour=1, tz = ""), ISOdate(2001, 1, 1, hour=23, tz = "")),
                   labels = date_format("%H"))

ggsave(file="TimeOfTheDayStudents.jpeg")

jpeg(file="DaysOfTheWeekStudents.jpeg")
barplot(table(factor(dfEmailsStudents$Day,levels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))), main="Total Number of Mails by Students",xlab="Number of Mails",ylab="Day of the Week",col="forestgreen")
dev.off()


# Time of the Day Faculty/Staff
temp <- dfEmails[dfEmails$Category!="Student Reps",]
dfEmailsNonStudents <- temp[temp$SenderMapped!="Mailman",]
dfTimeoftheDay <- with(dfEmailsNonStudents, aggregate(Subject, by=list(hh=hh, mm=mm), FUN=length))

start <- ISOdate(2001, 1, 1, hour=0, tz = "")
ggDaysoftheYear <- ggplot(dfTimeoftheDay, aes(x = start+60*(60*hh + mm),
                                              y=0,
                                              alpha = x/max(dfTimeoftheDay$x))
                          )

ggDaysoftheYear + geom_tile() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(), 
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(), 
        axis.ticks.x = element_blank(), 
        axis.text.y = element_blank(),
        panel.background = element_rect(fill = "white"),
        legend.position="none")  +
  scale_y_continuous(expand = c(0.01,0)) +
  scale_x_datetime(breaks = date_breaks("1 hour"),
                   limits = c(ISOdate(2001, 1, 1, hour=1, tz = ""), ISOdate(2001, 1, 1, hour=23, tz = "")),
                   labels = date_format("%H"))

ggsave(file="TimeOfTheDayFacultyStaff.jpeg")

jpeg(file="DaysOfTheWeekFacultyStaff.jpeg")
barplot(table(factor(dfEmailsNonStudents$Day,levels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))), main="Total Number of Mails by Faculty/Staff",xlab="Number of Mails",ylab="Day of the Week",col="forestgreen")
dev.off()
