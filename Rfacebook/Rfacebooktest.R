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


page.id <- "teepr" # TEEPR 趣味新聞
page <- getPage(page.id, fb.oauth, n = 3000)
page <- page[,-8]

teepr <- filter(page, type == "link") #keep only links
teepr_fix <- teepr[-863,]

alldata   <- data.frame()
link <- as.character(teepr_fix$link) #original link in data is "factors"!

for(i in 1: length(link)){
  url     <- link[i]
  doc     <- read_html(url)
  title   <- xml_text(xml_find_all(doc, '//*[@class=\"single_post\"]/header/h1')) #case by case
  subdata <- data.frame(title)
  alldata <- rbind(alldata, subdata)
}

teeprfull <- cbind(teepr_fix, alldata)
teeprfull_filter <-teeprfull[126:2971,]

write.csv(teeprfull_filter, file = "teepr.csv")
