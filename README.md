binQTL.shiny
========

This is the repository for the Shiny application presented in "binQTL: an R package for QTL mapping with binmap data“ (Yao et al. 2017).

Installation
------------

Launch binQTL.shiny directly from R and GitHub:
  - Before running the app you will need to have R and RStudio installed (tested with R 3.2.1 and RStudio 0.99.465).
  - Launch the R console

- Please run these lines in R:
  - install.packages("shiny")
  - install.packages("devtools")
  - devtools::install_github("rstudio/shiny-incubator")

- Then start the app:
  - shiny::runGitHub("binQTL.shiny", "venyao")

Your web browser will open the web app.

