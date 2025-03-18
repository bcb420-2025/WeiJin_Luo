#install required R and bioconductor packages
tryCatch(expr = { library("RCurl")}, 
         error = function(e) {  
           install.packages("RCurl")}, 
         finally = library("RCurl"))

gsea_jar = "/home/rstudio/GSEA_4.3.2/gsea-cli.sh"
working_dir = "~/projects/bcb420_code/WeiJin_Luo/HW_GSEA"
output_dir = "~/projects/bcb420_code/WeiJin_Luo/HW_GSEA"

analysis_name = "mesenchymal vs. immunoreactive ovarian cancer"
rnk_file = "MesenvsImmuno_RNASeq_ranks.rnk"
dest_gmt_file = ""

if(dest_gmt_file == ""){
  gmt_url = "http://download.baderlab.org/EM_Genesets/March_01_2025/Human/symbol/"
  
  #list all the files on the server
  filenames = getURL(gmt_url)
  tc = textConnection(filenames)
  contents = readLines(tc)
  close(tc)
  
  #get the gmt that has all the pathways and does not include terms 
  # inferred from electronic annotations(IEA)
  #start with gmt file that has pathways only and GO Biological Process only.
  rx = gregexpr("(?<=<a href=\")(.*.GOBP_AllPathways_noPFOCR_no_GO_iea.*.)(.gmt)(?=\">)",
                contents, perl = TRUE)
  gmt_file = unlist(regmatches(contents, rx))
  
  dest_gmt_file <- file.path(output_dir,gmt_file )
  
  #check if this gmt file already exists
  if(!file.exists(dest_gmt_file)){
    download.file(
      paste(gmt_url,gmt_file,sep=""),
      destfile=dest_gmt_file
    )
  }
}


command <- paste("", gsea_jar,
             "GSEAPreRanked -gmx", dest_gmt_file,
             "-rnk" ,file.path(working_dir, rnk_file), 
             "-collapse false -nperm 1000 -scoring_scheme weighted", 
             "-rpt_label ", analysis_name,
             "  -plot_top_x 20 -rnd_seed 12345  -set_max 200",  
             " -set_min 15 -zip_report false ",
             " -out", output_dir, 
             " > gsea_output.txt", sep=" ")
system(command)