### Christopher Shin 
### SEPTEMBER 19, 2023 
#
# This R file will take the Output of the RDOCK from Discovery Studio
#
#

setwd("/Users/chris/Documents/ASU_Work/Research_Singharoy")
getwd()
library(dplyr)
library(ggplot2)
library(tidyverse)
library(reshape2)

#Creating df for Energy Poses
poses <- read.table("PosesEnergy_2000.txt",sep=",",header = T)
View(poses)


#Recoding clusters as factor variables
length(unique(poses$Cluster))
cluster_factor <- factor(unique(poses$Cluster))
cluster_factor

poses$Cluster <- factor(poses$Cluster)
str(poses)

#Looking at how many poses are in each cluster
cluster_table <-table(poses$Cluster)
cluster_table.sorted <- cluster_table[order(cluster_table)]
cluster_table.sorted

length(poses$Cluster)

#Ranking the clusters by their median and mean E_RDock Score
median_E_RDock <- aggregate(poses$E_RDock~poses$Cluster, data=poses, FUN = median)
median_E_RDock
mean_E_RDock <- aggregate(poses$E_RDock~poses$Cluster, data=poses, FUN = mean)

min_ZRank <- aggregate(poses$ZRank.Score~poses$Cluster, data=poses, FUN = min)
min_ZRank
min_ZDock <- aggregate(poses$ZDock.Score~poses$Cluster, data=poses, FUN = min)
min_ZDock
stats_E_R_Dock <- cbind(median_E_RDock, mean_E_RDock$`poses$E_RDock`,
                        min_ZRank$`poses$ZRank.Score`, min_ZDock$`poses$ZDock.Score`)



View(median_E_RDock)
View(stats_E_R_Dock)
### Histograms ###
poses_2001 <- poses[poses$Cluster == "2001",]
ggplot(data = poses_2001, aes(x=poses_2001$E_RDock)) + 
  geom_histogram()

#Obtaining a new dataframe with only the elements in Cluster 1
poses_1 <- poses[poses$Cluster == "1",]
View(poses_1)

#Making a new df with only the ZRank and E_RDock scores
poses_1.s <- select(poses_1,ZRank.Score,E_RDock)
#Convert the new df into a single column
poses_1.m <- melt(poses_1.s[,1:2])
View(poses_1.m)

ggplot(poses_1.m) + 
  geom_histogram(aes(x = value, color = variable), fill = "grey",
                  alpha = 0.5,  bins = 20,
                 position = "identity") +
  labs(x="Energy (kJ)",title = "Cluster 1: RDock and ZRank scores")

#Histogram but placed in a separate image
png("two-hists.png", width=1000,height=500)
par(mfrow=c(2,1))
hist(x=poses_1$E_RDock, main = "Cluster 1: RDock score",
     xlim = c(-40,50))
hist(x=poses_1$ZRank.Score, main = "Cluster 1: ZRank Score",
     xlim = c(-120, 200))
dev.off()
  
poses$Cluster
?geom_histogram()
  
min(poses$ZRank.Score)


##Cluster 67
poses_67 <- poses[poses$Cluster == "67",]
View(poses_67)

#Making a new df with only the ZRank and E_RDock scores
poses_67.s <- select(poses_67,ZRank.Score,E_RDock)
#Convert the new df into a single column
poses_67.m <- melt(poses_67.s[,1:2])
View(poses_67.m)

ggplot(poses_67.m) + 
  geom_histogram(aes(x = value, color = variable), fill = "grey",
                 alpha = 0.5,  bins = 20,
                 position = "identity") +
  labs(x="Energy (kJ)",title = "Cluster 67: RDock and ZRank scores")




#### Addendum

#First histogram plot of cluster 1
ggplot(poses_1) +
  geom_histogram(aes(x=poses_1$E_RDock),color = "white", fill="aquamarine4",
                 alpha = 0.5, bins = 20) +
  geom_histogram(aes(x=poses_1$ZRank.Score),color = "white", fill="red",
                 alpha = 0.5, bins = 20) +
  labs(x="Energy (kJ)",title = "Cluster 1: RDock and ZRank scores")

