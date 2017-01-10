#### Merging PRISM and FIA Data 
# using the subset of the matched PRISM and FIA from Grant Domke "LS_data_081016.csv"
# Laura Dee - Jan 10 2017 

require(data.table)
reqiuire()
setwd("~/Google Drive/Tree growth drivers/data")

### Read in Data ######
  # matched PRISM and FIA data for a subset of sites (with lat long) 
  # ??? determine what subset Grant used. paper reference?
  for_prism_dat <- read.csv("LS_data_081016.csv")

  ## Load the FIA data for MN
  plotdat <- read.csv("MN_PLOT.csv")
  treespdat <-fread("MN_TREE.csv")
  conddat <- fread("MN_COND.csv")
  countydata <- read.csv("MN_COUNTY.csv")
  
  ## all species in FIA matching FIA species code to taxonomy and common name, which region etc
  speciescodes <- read.csv("REF_SPECIES_FIAcodes.csv")
  
### merge datasets by plot and inventory year ###
  climate_tree_MNdat <- merge(for_prism_dat, treespdat, by = c("PLT_CN", "INVYR"), all = FALSE)
  
## plot at relative growth by year ## 
  plot(GROWCFGS ~ INVYR, data = climate_tree_MNdat)
  
