######################################################
# Here, note the packages you need for your workflow.#
######################################################

if(!("desc" %in% installed.packages())) {
  ans <- menu(c("Yes", "No"), title="Need to install package desc first. Do you want this?")
  if(ans==1) {
    install.packages("desc")
  } else {
    stop("Please install package desc first.")
  }
}
library("desc", character.only = TRUE)

desc <- description$new()
deps_tab <- desc$get_deps()

deps_tab$package[!deps_tab$package %in% installed.packages()]



# This is just for loading the packages (do not edit) ---------------------

missing_pkg <- FALSE
for(pkg in cran) {
  if(!(pkg %in% installed.packages())) {
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
}
for(pkg in github) {
  stop("Packages from github not implemented yet")
}
for(pkg in other) {
  if(!(pkg %in% installed.packages())) {
    message("Please install package ",  pkg," first!")
    missing_pkg <- TRUE
  }
  library(pkg, character.only = TRUE)
}
if(missing_pkg) {
  stop("Cannot proceed. package(s) missing")
}

rm(cran, github, other, missing_pkg, pkg)
