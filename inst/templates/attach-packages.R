###############################################
# This file is for simple package management. #
###############################################

# Should packages only suggested be checked as well?
check_suggests <- TRUE

# Do not edit -------------------------------------------------------------

# attach package "desc" and try installing it if necessary
if(!("desc" %in% installed.packages())) {
  ans <- menu(c("Yes", "No"), title="Need to install package desc first. Do you want this?")
  if(ans==1) {
    install.packages("desc")
  } else {
    stop("Please install package desc first.")
  }
  rm(ans)
}
library("desc", character.only = TRUE)

# get packages from description file and check which are missing
desc <- description$new()
deps_tab <- desc$get_deps()
deps_tab <- deps_tab[!deps_tab$package=="R",] # sometimes R is listed as dependence

# ask if suggests should be installed and attached as well (if applicable)
if("Suggests" %in% deps_tab$type & check_suggests) {
  n_suggests <- sum(deps_tab$type == "Suggests")
  ans <- menu(c("Yes", "No"), title=paste0(n_suggests, " missing package",
                                           ifelse(n_suggests > 1, "s are", " is"),
                                           " only suggested. Do you want to install ",
                                           ifelse(n_suggests > 1, "them", "it"), "?"))
  if(ans==2) {
    deps_tab <- deps_tab[!deps_tab$type=="Suggests",]
  }
  rm(n_suggests)
}

# install missing packages
missing_pkgs <- deps_tab[!deps_tab$package %in% installed.packages(),]
if(length(missing_pkgs$package) > 0) {
  install.packages(missing_pkgs$package)
}

# attach packages
for(pkg in deps_tab$package) {
  library(pkg, character.only = TRUE)
}
rm(pkg)

rm(deps_tab, desc, missing_pkgs, check_suggests)
