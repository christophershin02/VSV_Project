library(plotly)
library(stringr)
library(dplyr)
library(data.table)
library(tidyverse)
library(ggpubr)
library(ggplot2)
library(cowplot)

### Function that takes in the PoseNum_ClusterNum and adds it to the conservation dataframe
read_epitope <- function(PoseNum_ClusterNum, antibody) {
  
  # Check if the dataframe already contains the specified column
  if (PoseNum_ClusterNum %in% colnames(conservation.df)) {
    cat("Column", PoseNum_ClusterNum, "already exists in the dataframe.\n")
  } else {
    # Adding a new column to the dataframe with all values being F
    conservation.df[[PoseNum_ClusterNum]] <- rep("F",times = length(conservation.df$Amino_Acid))
    cat("New column", PoseNum_ClusterNum, "added to the dataframe.\n")
  }
  
  #Making the directory path
  epitope_directory <- paste0("./Minimization/",antibody,"/",PoseNum_ClusterNum,"/epitope.txt")
  cat("Directory of epitope:", epitope_directory, "\n")
  
  #Opening up the epitope.txt and converting it to a list
  epitope <- read.table(epitope_directory,header = F)
  epitope <- as.list(epitope)
  epitope <- gsub("^A", "", epitope) 
  epitope <- gsub("^B", "", epitope) 
  epitope <- gsub("^C", "", epitope) 
  epitope <- unique(epitope) %>%
    as.numeric(epitope)
  cat("Epitope:", epitope, "\n")
  
  #Creating a new dataframe with the epitope booleans
  conservation.df[[PoseNum_ClusterNum]][c(epitope)] <- "T"
  assign(PoseNum_ClusterNum, conservation.df, envir = .GlobalEnv)
  cat("Global variable", PoseNum_ClusterNum, "created.\n")
  return(conservation.df)
}


### Making ggplot graph function (IGNORE)
make_graph <- function(pose_dataframe) {
  
  #Creating a variable to pass into fill = ()
  fill_col <- colnames(pose_dataframe[3])
  #Label for the legend
  label <- gsub("_"," ", fill_col)
  
  #Creating id and subgroup column
  pose_dataframe <- pose_dataframe %>% 
    mutate(id = seq(from = 1, to = length(Amino_Acid)), #Creating an id number for each amino acid
           subgroup = as.factor(ceiling(id/215))) #Making a subgroup, 
  cat("Mutating dataframe \n")
  

  #Making ggplot
  g <- ggplot(data = pose_dataframe,
              aes(x = factor(seq_along(Amino_Acid)),
                  y = Conservation_Score,
                  id = id,
                  Amino_Acid = Amino_Acid,
                  text = paste("ID:", id,"<br>Amino Acid:",Amino_Acid,"<br>Conservation Score",Conservation_Score),
                  fill = pose_dataframe[[fill_col]])) +
    geom_bar(stat = "identity") +
    geom_tile(aes(x=factor(seq_along(Amino_Acid)),
                  y=2.5,
                  fill=pose_dataframe[[fill_col]]),
                  height = 5,
                  alpha=0.3) +
    scale_fill_manual(values=c("black", "gold"),
                      labels = c("No", "Yes")) + 
    labs(
      x = NULL,
      y = NULL,
      fill = "On Epitope?",
      title = label
    ) +
    scale_x_discrete(breaks = seq(0, length(conservation.df$Amino_Acid), by = 5)) +
    theme(axis.text.x = element_text(color = "black", size = 4, angle = 90, hjust = .5, vjust = .5, face = "plain"),
          axis.text.y = element_text(color = "black", size = 10, angle = 0, hjust = 1, vjust = .5, face = "plain")) +
    theme(aspect.ratio = 0.3,
          legend.position = "none",
          axis.title = element_text(size = 8, vjust = 0),
          legend.text = element_text(size = 8),
          plot.title = element_text(color = "black", size = 18, face = 'bold')
          
    )
  #axis.title.x = element_text(color = "grey20", size = 12, angle = 0, hjust = .5, vjust = 0, face = "plain"),
  #axis.title.y = element_text(color = "grey20", size = 12, angle = 90, hjust = .5, vjust = .5, face = "plain"))
  cat("Created ggplot \n")
  
  return(g)
 
  
}




### Function that takes in the residue id number and whichever poses you want to compare. It will check each pose at the res_id and output whether the res_id is at the epitope
#Example: compare_sequences(1,Pose110_Cluster50,Pose119_Cluster54,Pose348_Cluster85)
#This will compare the epitope boolean value for each of the poses at residue 1
compare_sequences <- function(id_num, ...) {
  pose_list <- list(...)
  
  for (i in 1:length(pose_list)) {
    column_names <- colnames(pose_list[[i]]) 
    epitope_column <- column_names[3]
    amino_acid_column <- column_names[1]
    
    epitope_value <- pose_list[[i]][id_num, epitope_column]
    amino_acid <- pose_list[[i]][id_num, amino_acid_column]
    cat(paste0(epitope_column," residue_num|amino_acid|epitope_boolean: ",id_num,amino_acid," ",epitope_value,"\n"))
  }

}

# Save a legend of a ggplot
get_legend<-function(myggplot){
  tmp <- ggplot_gtable(ggplot_build(myggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}
