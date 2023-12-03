library(ggplot2)
library(plotly)
library(stringr)
library(dplyr)
library(data.table)
library(tidyverse)
library(ggpubr)
library(gridExtra)
library(cowplot)
library(patchwork)
library(grid)
library(gridtext)
library(htmlwidgets)
library(htmltools)

setwd('/Users/chris/Documents/ASU_Work/Research_Singharoy/VSV_AB_Project/')

#Importing dataset
conservation.df <- read.csv('conservation-dataframe.csv', colClasses = "character",
                            stringsAsFactors = FALSE, na.strings = character(0))

#Viewing the dataframe
View(conservation.df)
conservation.df
str(conservation.df)

#Dropping the first irrelevant column
conservation.df <- conservation.df[-1]

#Changing the name of the column variables to take out the "X"
colnames(conservation.df)
new_colnames <- gsub("^X", "", colnames(conservation.df))
colnames(conservation.df) <- new_colnames

#Transpose the dataframe
conservation.df <- as.data.frame(t(conservation.df))


#Renaming the new column names
colnames(conservation.df) <- c("Amino_Acid","Conservation_Score")

#Converting the conservation scores into factor variables
# 4 = " ": No conservation
# 3 = "." Weakly conserved
# 2 = ":" Strongly conserved
# 1 = "*" Fully Conserved
conservation.df$Conservation_Score <- recode_factor(conservation.df$Conservation_Score,
                                                    "1" = " ", "2" = ".","3"=":","4"="*")


#Using the function
read_epitope("Pose3_Cluster14","1E9")
read_epitope("Pose75_Cluster29","1E9")
read_epitope("Pose110_Cluster50","1E9")
read_epitope("Pose24_Cluster16","1E9")
read_epitope("Pose471_Cluster99","1E9")
read_epitope("Pose137_Cluster88","8G5")
read_epitope("Pose157_Cluster67","8G5")
read_epitope("Pose119_Cluster54","8G5")
read_epitope("Pose348_Cluster85","8G5")
read_epitope("Pose349_Cluster91","8G5")

######### ggplot ############

## USING FUNCTION

### 1E9 ###
pose3 <- make_graph(Pose3_Cluster14)
pose75 <- make_graph(Pose75_Cluster29)
pose110 <- make_graph(Pose110_Cluster50)
pose24 <- make_graph(Pose24_Cluster16)
pose471 <- make_graph(Pose471_Cluster99)

pose3
# Note: These plots will have no x-axis/y-axis label or no legend

### 8G5 ###
pose137 <- make_graph(Pose137_Cluster88)
pose157 <- make_graph(Pose157_Cluster67)
pose119 <- make_graph(Pose119_Cluster54)
pose348 <- make_graph(Pose348_Cluster85)
pose349 <- make_graph(Pose349_Cluster91)

## Making plotly graphs

### 1E9 ###
pose3_plotly <- ggplotly(pose3, 
                         tooltip = "text") %>%
  layout(hovermode = "closest")
pose3_plotly
saveWidget(pose3_plotly, file = "pose3_1E9.html")

pose75_plotly <- ggplotly(pose75,
                          tooltip = "text")
saveWidget(pose75_plotly, file = "pose75_1E9.html")

pose110_plotly <- ggplotly(pose110, 
                           tooltip = "text")
saveWidget(pose110_plotly, file = "pose110_1E9.html")

pose24_plotly <- ggplotly(pose24, 
                          tooltip = "text")
saveWidget(pose24_plotly, file = "pose24_1E9.html")

pose471_plotly <- ggplotly(pose471, 
                           tooltip = "text")
saveWidget(pose471_plotly, file = "pose471_1E9.html")

### 8G5 ###
pose137_plotly <- ggplotly(pose137, 
                         tooltip = "text") %>%
  layout(hovermode = "closest")
pose137_plotly
saveWidget(pose137_plotly, file = "pose137_8G5.html")

pose157_plotly <- ggplotly(pose157,
                          tooltip = "text")
saveWidget(pose157_plotly, file = "pose157_8G5.html")

pose119_plotly <- ggplotly(pose119, 
                           tooltip = "text")
saveWidget(pose119_plotly, file = "pose119_8G5.html")

pose348_plotly <- ggplotly(pose348, 
                          tooltip = "text")
saveWidget(pose348_plotly, file = "pose348_8G5.html")

pose349_plotly <- ggplotly(pose349, 
                           tooltip = "text")
saveWidget(pose349_plotly, file = "pose349_8G5.html")







### Combining the graphs

## 1E9 ##
#Note: If this doesnt work you might have to go to the epitope-functions.R and change legend.position = "top" or something
pose3.legend <- pose3 + theme(legend.position = "top")
pose3.legend
legend <- get_legend(pose3.legend)
legend 
#Creating the x and y axis labels
title.Grob <- textGrob("Top 5 Poses for 1E9 Antibody", gp=gpar(fontsize = 20))

txt <-  "<b>Figure 1: Top 5 Poses for 1E9 Antibody:</b>
                              The sequences shown above correspond to the poses with<br>
                              the lowest potential energy at the epitote between the 5I2S
                              protein and the 1E9 antibody. An asterisk (*) indicates positions <br>
                              which have a single, fully conserved residue. A colon (:) indicates 
                              conservation between groups of strongly similar properties. <br> 
                              A period (.) indicates conservation between groups of weakly similar 
                              properties. A space ( ) indicates no conservation."
text.Grob <- richtext_grob(text = txt,
                           gp = gpar(fontsize = 8, just = "left")
                          )
grid.newpage()
grid.draw(text.Grob)
legend.Grob <- textGrob(" ' ' No conservation  '.' Weakly conserved \n ':' Strongly conserved  '*' Fully Conserved")

y.grob <- textGrob("Conservation Score",
                   gp=gpar(fontsize=15), rot=90)

x.grob <- textGrob("Residue Number", vjust = 0,
                   gp=gpar(  fontsize=15))

#Combining all the plots together
figure_1E9 <- pose3 + pose75 + pose110 + pose24 + pose471 +
  plot_layout(ncol = 1, nrow = 5,  heights = c(25,25,25,25,25)) 

#Arranging the elements
fig1 <- grid.arrange(title.Grob,legend.Grob,legend,patchworkGrob(figure_1E9),
                     nrow=4,ncol=1, heights = c(0.6,0.6,0.2,16),
                     left = y.grob, bottom = x.grob)

ggsave("1E9_test.png", fig1 ,width = 10, height = 22, units = "in", limitsize = FALSE)


## 8G5 ##
#Note: If this doesnt work you might have to go to the epitope-functions.R and change legend.position = "top" or something
pose3.legend <- pose3 + theme(legend.position = "top")
pose3.legend
legend <- get_legend(pose3.legend)
legend 
#Creating the x and y axis labels
title.Grob.8G5 <- textGrob("Top 5 Poses for 8G5 Antibody", gp=gpar(fontsize = 20))

legend.Grob <- textGrob (" ' ' No conservation  '.' Weakly conserved \n ':' Strongly conserved  '*' Fully Conserved")

y.grob <- textGrob("Conservation Score",
                   gp=gpar(fontsize=15), rot=90)

x.grob <- textGrob("Residue Number", vjust = 0,
                   gp=gpar(  fontsize=15))

#Combining all the plots together
figure_8G5 <- pose137 + pose157 + pose119 + pose348 + pose349 +
  plot_layout(ncol = 1, nrow = 5,  heights = c(25,25,25,25,25)) 

#Arranging the elements
fig2 <- grid.arrange(title.Grob.8G5,legend.Grob,legend,patchworkGrob(figure_8G5),
                     nrow=4,ncol=1, heights = c(0.6,0.6,0.2,16),
                     left = y.grob, bottom = x.grob)

ggsave("8G5_test.png", fig2 ,width = 10, height = 22, units = "in", limitsize = FALSE)


#####################
#figure1 <- grid.arrange(pose3.legend, pose75, pose110, pose24, pose471,
            # ncol = 1, nrow = 5)

#figure2 <- ggarrange(pose137, pose157, pose119, pose348, pose349,
                   #  ncol = 1, nrow = 5)

# Save the figure


### TEST IMAGES ###
#figure1 <- ggarrange(pose3, pose75, pose110, pose24, pose471,
#  ncol = 1, nrow = 5)

#ggsave("8G5_test.png", figure2 ,width = 10, height = 20, units = "in", limitsize = FALSE)
##############################



##################################################################
#######Pose3_Cluster14 Epitope TEST

#Creating 0 in a new column
conservation.df$pose_3_epitope <- rep("False",times = 422)

epitope_pose3 <- c("A32 A33 A34 A35 A36 A191 A192 A196 A197 A198 A199 A200 A201 A202 A203 A212 A214 A215 A216 A217 A218 A219 A220 A232 A248 A249 A250 A251 A252 A253 A254 A255 A256 A257 A258 A268 A269 A270 A271 C1 C2 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C185 C186 C187 C189 C195 C335 C336 C337 C338 C339 C340 C341 C342 C344 C346 C347 C349 C350 C351 C352 C353")

#Creating a list where each element is seperated by a space
epitope_pose3 <- as.list(strsplit(epitope_pose3, " ")[[1]])
epitope_pose3 <- gsub("^A", "", epitope_pose3) 
epitope_pose3 <- gsub("^B", "", epitope_pose3) 
epitope_pose3 <- gsub("^C", "", epitope_pose3)
epitope_pose3 <- unique(epitope_pose3) %>%
  as.numeric(epitope_pose3)
epitope_pose3
conservation.df$pose_3_epitope[c(epitope_pose3)] <- "True"




#Creating id and subgroup column
Pose3_Cluster14 <- Pose3_Cluster14 %>% 
  mutate(id = seq(from = 1, to = length(Amino_Acid)), #Creating an id number for each amino acid
         subgroup = as.factor(ceiling(id/215))) #Making a subgroup, 

#Making ggplot
pose3 <- ggplot(data = Pose3_Cluster14,
                aes(x = factor(seq_along(Amino_Acid)),
                    y = Conservation_Score,
                    id = id,
                    Amino_Acid = Amino_Acid,
                    fill = Pose3_Cluster14)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values=c("black", "gold")) + 
  labs(
    x = "Residue Number",
    y = "Conservation Score",
    title = "Pose 3 Cluster 14 Sequence"
  ) +
  scale_x_discrete(breaks = seq(0, length(conservation.df$Amino_Acid), by = 5)) +
  facet_wrap(~subgroup, scales = "free_x", ncol = 1) +
  theme(axis.text.x = element_text(color = "black", size = 4, angle = 90, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 6, angle = 0, hjust = 1, vjust = .5, face = "plain")) 
#axis.title.x = element_text(color = "grey20", size = 12, angle = 0, hjust = .5, vjust = 0, face = "plain"),
#axis.title.y = element_text(color = "grey20", size = 12, angle = 90, hjust = .5, vjust = .5, face = "plain"))

pose3

pose3_plotly <- ggplotly(pose3, tooltip = c("id","Amino_Acid","Conservation_Score"))

print(pose3_plotly)