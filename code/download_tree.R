download_tree <- function(state){
  path <- "data"
  dir.create(path, FALSE)
  state_csv <- paste0(state,"_TREE.csv")
  destfile <- paste0("data/",state_csv)
  dwld <- paste0("https://apps.fs.usda.gov/fiadb-downloads/CSV/",state_csv)
  downloader::download(dwld, destfile= destfile)
}

setwd("~/Google Drive/Tree growth drivers/data/")
statesFIA <- read.csv("data/REF_FIAstatecodes.csv")
state_list <- as.character(unique(statesFIA$STATE_ABBR))
# state_list <- c("CT","MA")

#Download state level tree data
lapply(state_list[c(7,22)], download_tree)
