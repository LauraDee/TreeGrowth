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

#TO DO add real state list
state_list <- c("CT","MA")
#Download state level tree data
lapply(state_list, download_tree)
