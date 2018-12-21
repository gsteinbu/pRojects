#' Create a project for high performance experiments with batchtools
#'
#' A structure template for a project using the package \link[batchtools]. Inspired by Cookiecutter.
#'
#' ├─ \strong{make.R}               \emph{Commands to perform experiments (e.g. \code{\link[batchtools]{submitJobs}}).}\cr
#' ├─ \strong{DESCRIPTION}          \emph{Info about authors, version and packages used (to attach them).}\cr
#' ├─ \strong{README.md}            \emph{README for developers of this project.}\cr
#' │\cr
#' ├─ \strong{data}\cr
#' │  ├─ \strong{processed}         \emph{The processed, canonical data sets for the experiments.}\cr
#' │  └─ \strong{raw}               \emph{The original, immutable data dump.}\cr
#' │\cr
#' ├─ \strong{references}           \emph{Data dictionaries, articles, and all other explanatory materials.}\cr
#' │\cr
#' ├─ \strong{reports}              \emph{Reports for project. E.g., R markdown notebooks.}\cr
#' │  ├─ \strong{knitr}             \emph{Generated reports as HTML, PDF, LaTeX, etc..}\cr
#' │  │  └─ \strong{figures}        \emph{Graphics and figures to be used in reporting.}\cr
#' │  └─ \strong{markdown}          \emph{R notebooks. Naming convention is a number (for ordering), the creator's initials, and a short '-' delimited description, e.g. '1.0-jqp-initial-data-exploration'.}\cr
#' │\cr
#' ├─ \strong{R}                    \emph{Source code for use in this project.}\cr
#' │  ├─ \strong{attach-packages.R} \emph{Attach packages needed (given in description file).}\cr
#' │  ├─ \strong{functions.R}       \emph{Functions for experiments.}\cr
#' │  ├─ \strong{problems.R}        \emph{Problems for experiments.}\cr
#' │  ├─ \strong{algorithms.R}      \emph{Algorithms for experiments.}\cr
#' │  └─ \strong{design.R}          \emph{Design of experiments.}\cr
#' │\cr
#' └─ \strong{<NAME>.Rproj}         \emph{Rstudio project file.}\cr
#'
#' @inheritParams createBasicProject
#' @param dirs Directories to create
#'
#' @source <https://mllg.github.io/batchtools/index.html>
#' @source <https://drivendata.github.io/cookiecutter-data-science/>
#'
#' @export
#'
#' @examples
#' \dontrun{
#' folder <- tempdir()
#' createBatchtoolsProject(name = "doggos", title = "Counting cute dogs",
#'                    folder = folder,
#'                    packagedeps = "none",
#'                    git = TRUE, external_setup = NULL,
#'                    reset = TRUE)
#' }
createBatchtoolsProject <- function(name, title = NULL,
                                    folder = getwd(),
                                    packagedeps = "packrat",
                                    git = TRUE,
                                    reset = TRUE,
                                    external_setup = NULL,
                                    dirs = c("data",
                                             "data/raw",
                                             "data/processed",
                                             "references",
                                             "reports",
                                             "reports/markdown",
                                             "reports/knitr",
                                             "reports/knitr/figures")) {
  packagedeps <- match.arg(packagedeps, okpackagedeps())

  current_proj <- get_current_proj()
  tryCatch({
    createBasicProject(name = name,
                       title = title,
                       folder = folder,
                       packagedeps = packagedeps,
                       git = FALSE,
                       external_setup = external_setup,
                       reset = FALSE)
    createdirs(dirs)

    # Content of files inspired by mtcars drake example
    fileNames <- c("make", "plan", "functions", "packages")
    for(fileName in fileNames) {
      fileName <- usethis:::slug(fileName, "R")
      usethis::use_template(paste0("drake/", fileName),
                            save_as = ifelse(fileName=="make",
                                             fileName,
                                             paste0("R/", fileName)),
                            data = list(), ignore = FALSE,
                            open = FALSE, package = "pRojects")
    }
    usethis:::done("Writing initial R files")

    usethis:::todo("Remember to choose a license. See https://choosealicense.com for details.")

    if (git){
      usethis::use_git(message = cool_first_commit())
    }
  }
  ,
  error = function(e) {
    message(paste("Error:", e$message))
    e
    # delete folder created earlier
    unlink(file.path(folder, name), recursive = TRUE)
    message(sprintf("Oops! An error was found and the `%s` directory was deleted", name))
  }
  )
  reset_proj(current_proj)
  invisible(TRUE)


}
