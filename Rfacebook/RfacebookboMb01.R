#install package online
library(devtools)
#install from developer's github account
#install_github("pablobarbera/Rfacebook/Rfacebook")
library(Rfacebook)
library(xml2)
library(dplyr)

#To be authenticated by Facebook app 
#(you can check the process on https://blog.gtwang.org/r/facebook-social-media-mining-with-r/)
#Using FB token is another easier way but it has time limit.   

fb.oauth <- fbOAuth(
  app_id="147196615743293", #mine
  app_secret="df3664c985db2a1e6e51fe09b7267df4", #mine
  extended_permissions = TRUE)

#You can save it for future use.(By then, you can get it by using codes#18.) 
save(fb.oauth, file="fb_oauth")
load("fb_oauth")


page.id <- "bomb01.tw" # boMb01
page <- getPage(page.id, fb.oauth, n = 3000)
page <- page[,-8]

bomb01 <- filter(page, type == "link") #keep only links
bomb01 <- bomb01[-2286,]

alldata   <- data.frame()
link <- as.character(bomb01$link) #original link in data is "factors"!

for(i in 2498: 2842){
  url     <- link[i]
  doc     <- read_html(url)
  title   <- xml_text(xml_find_all(doc, '//*[@id=\"article\"]/div/h1')) #case by case
  subdata <- data.frame(title)
  alldata <- rbind(alldata, subdata)
}
f<- alldata
a <- rbind(a,f)
#1101 1254 1825 2125 2165 2288(http://www.bomb01.com/article/32602)
bombfull <- cbind(bomb01, a)
bombfull_filter <-bombfull[138:2842,]

write.csv(bombfull_filter, file = "bomb01.csv")
