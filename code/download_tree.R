#### Downloading the FIA data, the "TREE" files by state from 
# https://apps.fs.usda.gov/fiadb-downloads/CSV/datamart_csv.html
## Jan 2017 
# Habacuc FM and Laura Dee 

## create a function to download the _TREE.csv files for each state 
path <- "data"
dir.create(path, FALSE)
download_tree <- function(state){
  path <- "data"
  dir.create(path, FALSE)
  state_csv <- paste0(state,"_TREE.csv")
  destfile <- paste0("data/",state_csv)
  dwld <- paste0("https://apps.fs.usda.gov/fiadb-downloads/CSV/",state_csv)
  downloader::download("https://apps.fs.usda.gov/fiadb-downloads/CSV/AR_TREE.csv", destfile= destfile)
}

## Download the state list and then apply the function to download and save the data to our GoogleDrive
setwd("~/Google Drive/Tree growth drivers/data/")
statesFIA <- read.csv("REF_FIAstatecodes.csv")
state_list <- unique(statesFIA$STATE_ABBR)
# state_list <- c("CT","MA")

## HABA: will this state_list work or does it need to enter in " " ?  ## 

#Download state level tree data
lapply(state_list, download_tree)
