library(stringr)
files <- list.files('/work/gd134/staph-rnaseq/', pattern = "GT24-[0-9]*")
samps <- str_extract(files, "GT24-[0-9]*")

sapply(samps, function(x) dir.create(paste0("/work/gd134/staph-rnaseq/",x)))



md_df <- data.frame(
  'media' = str_extract(files, "_[acidchelexsaltTSB]*_"),
  'rep' = str_extract(files, "-[ABCD]*_"),
  'batch' = str_extract(files, "batch_[123]*"),
  'strain' = str_extract(files, "-[c0-9TuGFPUSA300LAC]*-"),
  'species' = str_extract(files, "-[aureusepi]*-"),
  'samp_num' = samps,
  'file' = files
)

write.csv(md_df,"/hpc/group/ohlab/doingg/big-little-data/plot_comp/staph_rnaseq_metadata.csv")



sapply(c(1:length(files)), function(x) file.rename(from = paste0("/work/gd134/staph-rnaseq/", files[x]),
                                                   to = paste(paste0("/work/gd134/staph-rnaseq/", samps[x]),
                                                              files[x], sep ="/"))
)