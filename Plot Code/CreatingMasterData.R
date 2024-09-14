All_Disabled <- read.csv("All-WithD.csv")
All_Not_Disabled <- read.csv("All-WithNoD.csv")
All_Disabled_Men <- read.csv("Men-WithD.csv")
All_Disabled_Women <- read.csv("Women-WithD.csv")
All_Not_Disabled_Women <- read.csv("Women-WithNoD.csv")
All_Not_Disabled_Men <- read.csv("Men-WithNoD.csv")

colnames(All_Disabled) <- c("Date", "NC")
colnames(All_Not_Disabled) <- c("Date", "NC")
colnames(All_Disabled_Men) <- c("Date", "NC")
colnames(All_Disabled_Women) <- c("Date", "NC")
colnames(All_Not_Disabled_Men) <- c("Date", "NC")
colnames(All_Not_Disabled_Women) <- c("Date", "NC")

Master_Data_Frame <- data_frame(All_Disabled$Date, All_Disabled$NC, All_Not_Disabled$NC, All_Disabled_Men$NC, 
                       All_Disabled_Women$NC, All_Not_Disabled_Men$NC, All_Not_Disabled_Women$NC)

colnames(Master_Data_Frame) <- c("Date", "EPRAWD", "EPRAW/OD", "EPRMWD", "EPRWWD", "EPRMW/OD", 
                                 "EPRWW/OD")
write.csv(Master_Data_Frame, "...Master_Data.csv")

