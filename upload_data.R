#
# upload_data.R
#
# Upload data to CellEngine.
#
# 2020_08_14  WTR
#
#
################################################################################
################################################################################
#                     Copyright Still Pond Cytomics LLC 2019.                 ##
#        All Rights Reserved. No part of this source code may be reproduced   ##
#            without Still Pond Cytomics' express written consent.            ##
################################################################################
################################################################################


library(wadeTools)
library(cellengine)

# retrieve username, password
uid = Sys.getenv("ce_id")
pwd = Sys.getenv("ce_pw")
authenticate(username = uid, password = pwd)

# # Create Experiment
res_exp = createExperiment(list("name" = "PICI_0033_Penn"))
exp_id = res_exp$`_id`

# on restart, retrieve existing experiment
idx = which(getExperiments()$name == "PICI_0033_Penn")[1]
exp_id = getExperiments()$`_id`[idx]

# Where are the data
data_base = "~/Data/Independent_Consulting/Penn/PICI/data/PICI_0033/"

folders = dir(data_base, pattern = "PICI")

# eliminate irrelevant folders
idx = grep(pattern = "Comps", x = folders)
folders = folders[-idx]

for (fld in folders) {
  cat("working on folder", fld, "\n")
  setwd(paste(data_base, fld, sep = ""))

  # upload each file to the CellEngine server
  files = dir()
  for (i in 1:length(files)) {
    fn = files[i]
    cat("\t", fn, "...")
    # check that R can read this file
    ff = suppressWarnings(read.FCS(fn))
    if (is(ff) == "flowFrame") {
      cat("reading file successful ... ")
    } else {
      cat("reading file NOT successful ... ")
    }
    res_file = uploadFcsFile(experimentId = exp_id, fcsFilePath = fn)
    file_id = res_file$`_id`

    # annotate file with folder
    annotateFcsFile(experimentId = exp_id, fcsFileId = file_id, annotations = list("folder" = fld))
    cat("done.\n")
  }

}




