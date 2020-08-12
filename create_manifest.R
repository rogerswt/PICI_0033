#
# create_manifest.R
#
# Create csv files that link FCS files to the Excel manifest.  Start by making a
# list of all files.  Then merge by participant_id.
#
#   2020-08-12  WTR
#

library(wadeTools)

proj_base = "~/Data/Independent_Consulting/Penn/PICI/"
data_base = tight(proj_base, "data/PICI_0033/")

nk_list = read.csv(tight(data_base, "nk_cell_manifest.csv"))
t_list = read.csv(tight(data_base, "t_cell_manifest.csv"))

# retrieve the filenames
all_files = dir(data_base, recursive = TRUE)

# eliminate non-fcs files
idx = grep(pattern = "fcs", x = all_files)
files = all_files[idx]

# eliminate comp controls
idx = grep(pattern = "Comp", x = files)
files = files[-idx]

# eliminate PBMC files
idx = grep(pattern = "PBMC", x = files)
files = files[-idx]

# eliminate CST files
idx = grep(pattern = "CST", x = files)
files = files[-idx]

# eliminate Template files
idx = grep(pattern = "Template", x = files)
files = files[-idx]

# separate the list into T cells and NK cells
idx = grep(pattern = "NK", x = files)
nk_files = files[idx]
t_files = files[-idx]

# We will merge by Specimen.Barcode.  First, we need to extract the specimen
# barcodes from the filenames.
#   NK cells
res_nk = sapply(X = strsplit(x = nk_files, split = "_"), FUN = function(x){x[length(x)]})
res_nk = sub(pattern = ".fcs", replacement = "", x = res_nk, fixed = TRUE)
frm_nk = data.frame(filename = nk_files, Specimen.Barcode = res_nk)

# merge
nk_manifest = merge(frm_nk, nk_list)

#   T cells
res_t = sapply(X = strsplit(x = t_files, split = "_"), FUN = function(x){x[length(x)]})
res_t = sub(pattern = ".fcs", replacement = "", x = res_t, fixed = TRUE)
frm_t = data.frame(filename = t_files, Specimen.Barcode = res_t)

# merge
t_manifest = merge(frm_t, t_list)

# we unfortunately used the name 'manifest' earlier, so save these as 'fillist' files.
write.csv(x = nk_manifest, file = tight(data_base, "nk_fillist.csv"))
write.csv(x = t_manifest, file = tight(data_base, "t_fillist.csv"))




