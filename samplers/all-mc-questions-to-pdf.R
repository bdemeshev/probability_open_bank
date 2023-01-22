# this file creates a pdf with all mc questions

# install.packages("exams", repos="http://R-Forge.R-project.org")
# devtools::install_github("bdemeshev/rexamsconverter")

library(tidyverse)
library(rio)

library(exams)
library(rexamsconverter)

files_df = tibble(filename = 
                    list.files('../base/', pattern = "*", full.names = TRUE, recursive = TRUE))

files_df = filter(files_df, str_detect(filename, '-mc-'))


# res = exams2pdf_source(files_df$filename, date = "2021-xx-yy",
#                       add_seed = 12378,
#                 n_vars = 1, title = "Подборочка",
#                 institution = "Поехали :)", nops = FALSE, shuffle = TRUE,
#                 template = "plain_no_sweave.tex",
#                 header = "\\input{../header.tex}",
#                 output_dir = "output/")



options(texi2dvi = Sys.which('xelatex'), exams_tex = 'tools') 
# 'tools' means 'dont use tinytex', and then select engine!

res = exams2pdf_source(files_df$filename, date = "2023-01-22",
                       n_vars = 1, title = "all-multiple-choice", institution = "exam", 
                       nops = FALSE, shuffle = TRUE,
                       add_seed = 158,
                       template = "../templates/all-multiple-choice-template.tex",
                       output_dir = paste0("../snapshots/all-multiple-choice/"))


