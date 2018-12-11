#' Create an Cookiecutter data science project
#'
#' Folder structure adopted from Cookiecutter data science.
#'
#' ├─ \strong{LICENSE}\cr
#' ├─ \strong{makefile.R}       \emph{Makefile with commands like 'make(data)' or 'make(train)'.}\cr
#' ├─ \strong{README.md}        \emph{The top-level README for developers using this project.}\cr
#' │\cr
#' ├─ \strong{data}\cr
#' │  ├─ \strong{external}      \emph{Data from third party sources.}\cr
#' │  ├─ \strong{interim}       \emph{Intermediate data that has been transformed.}\cr
#' │  ├─ \strong{processed}     \emph{The final, canonical data sets for modeling.}\cr
#' │  └─ \strong{raw}           \emph{The original, immutable data dump.}\cr
#' │\cr
#' ├─ \strong{packrat}          \emph{Default location for \link{packrat}.}\cr
#' ├─ \strong{models}           \emph{Trained models, model predictions, or model summaries ('save()' or 'load()')}\cr
#' ├─ \strong{notebooks}        \emph{R notebooks. Naming convention is a number (for ordering), the creator's initials, and a short '-' delimited description, e.g. '1.0-jqp-initial-data-exploration'.}\cr
#' ├─ \strong{references}       \emph{Data dictionaries, manuals, and all other explanatory materials.}\cr
#' │\cr
#' ├─ \strong{reports}          \emph{Generated analysis as HTML, PDF, LaTeX, etc.}\cr
#' │   └─ \strong{figures}      \emph{Generated graphics and figures to be used in reporting}\cr
#' │\cr
#' ├─ \strong{R}                \emph{Source code for use in this project (e.g. functions).}\cr
#' │  ├─ \strong{data}          \emph{To download or generate data.}\cr
#' │  ├─ \strong{features}      \emph{To turn raw data into features for modeling.}\cr
#' │  ├─ \strong{models}        \emph{To train models and then use trained models to make predictions.}\cr
#' │  ├─ \strong{visualization} \emph{To create exploratory and results oriented visualizations.}\cr
#' │  └─ \strong{plans}         \emph{For plans from \link{drake}.}\cr
#' │\cr
#' └─ \strong{initialize.R}  \emph{Things to do when cloning the project.}\cr
#'
#' @inheritParams createBasicProject
#' @source <https://drivendata.github.io/cookiecutter-data-science/>
#'
#' @export
#'
#' @examples
#' \dontrun{
#' folder <- tempdir()
#' createCookieProject(name = "doggos", title = "Counting cute dogs",
#'                     folder = folder,
#'                     packagedeps = "none",
#'                     git = TRUE, external_setup = NULL,
#'                     reset = TRUE)
#' list.files(file.path(folder, "doggos"))
#' unlink(file.path(folder, "doggos"))
#' }
createCookieProject <- function(name, title = NULL,
                                  folder = getwd(),
                                  packagedeps = "packrat",
                                  git = TRUE,
                                  reset = TRUE,
                                  external_setup = NULL) {
  packagedeps <- match.arg(packagedeps, okpackagedeps())

  dirs <- c("data",
            "data/external",
            "data/interim",
            "data/processed",
            "data/raw",
            "models",
            "notebooks",
            "references",
            "reports",
            "reports/figures",
            "R",
            "R/data",
            "R/features",
            "R/models",
            "R/visualization")

  current_proj <- get_current_proj()
  tryCatch({
    createBasicProject(name = name,
                       title = title,
                       folder = folder,
                       packagedeps = packagedeps,
                       git = git,
                       external_setup = external_setup,
                       reset = FALSE)
    createdirs(dirs)
    cat("Choose a license. See https://choosealicense.com for details.",
        file = file.path(usethis::proj_get(), "LICENSE"))
    # name_str <- "Please give your name for the license."
    # license <- menu(c("MIT", "GPL v3", "Apache 2.0", "CC0", "None"),
    #                 title="Choose a license. See https://choosealicense.com for more details and other options.")
    # switch (as.character(license),
    #         "0" = warning("No license chosen."),
    #         "1" = usethis::use_mit_license(name = "YOUR NAME"),
    #         "2" = usethis::use_gpl3_license(name = "YOUR NAME"),
    #         "3" = usethis::use_apl2_license(name = "YOUR NAME"),
    #         "4" = usethis::use_cc0_license(name = "YOUR NAME"),
    #         "5" = warning("No license chosen.")
    # )
    cat("library(\"drake\")\n",
        file = file.path(usethis::proj_get(), "makefile.R"))
    file.create(file.path(usethis::proj_get(), "initialize.R"))
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
