#### Downloading the FIA data, the "TREE" files by state from 
# https://apps.fs.usda.gov/fiadb-downloads/CSV/datamart_csv.html
## Jan 2017 


## create a function to download the _TREE.csv files for each state download_tree <- function(state){
  path <- "data"
  dir.create(path, FALSE)
  state_csv <- paste0(state,"_TREE.csv")
  destfile <- paste0("data/",state_csv)
  dwld <- paste0("https://apps.fs.usda.gov/fiadb-downloads/CSV/",state_csv)
  downloader::download(dwld, destfile= destfile)
}

#get list of state abbreviations from the FIA data 
setwd("~/Google Drive/Tree growth drivers/data/")
statesFIA <- read.csv("data/REF_FIAstatecodes.csv")
state_list <- as.character(unique(statesFIA$STATE_ABBR))
# or do manually or for a subset of states:
#state_list <- c("CT","MA")

#Download state level tree data
lapply(state_list[c(7,22)], download_tree)

#Parallel version of function above
library(parallel)
no_cores <- detectCores() - 1
#Initialise cluster
cl <- makeCluster(no_cores)
#get library support needed to run the code
clusterEvalQ(cl, library(downloader))
#put objects in place that might be needed for the code
clusterExport(cl,c("state_list"))
# parallel replicate...
ptm <- proc.time()
parLapply(cl,state_list, download_tree)

#gapped_list <-parLapply(cl, 1:50, function(i,...){ x <- six_gap; l<-x[sample(1:nrow(x),round(nrow(x)/2),replace = TRUE),]})
proc.time() - ptm
#stop the cluster
stopCluster(cl)
