#' Create a project laid out for an analysis project
#'
#' @inheritParams createBasicProject
#' @param dirs Directories to create
#'
#' @export
#'
#' @examples
#' \dontrun{
#' folder <- tempdir()
#' createAnalysisProject(name = "doggos", title = "Counting cute dogs",
#'                    folder = folder,
#'                    packagedeps = "none",
#'                    git = TRUE, external_setup = NULL,
#'                    reset = TRUE,
#'                    dirs = c("cats", "dogs"))
#' list.files(file.path(folder, "doggos"))
#' unlink(file.path(folder, "doggos"))
#' }
createAnalysisProject <- function(name, title = NULL,
                                  folder = getwd(),
                                  packagedeps = "packrat",
                                  git = TRUE,
                                  reset = TRUE,
                                  external_setup = NULL,
                                  dirs = c("data", "analysis", "outputs")) {
  packagedeps <- match.arg(packagedeps, okpackagedeps())

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
