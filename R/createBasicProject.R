#' Create a very basic project directory
#'
#' Is the basis for all other projects.
#'
#' ├─ \strong{DESCRIPTION}          \emph{Info about authors, version and packages used (to attach them).}\cr
#' ├─ \strong{README.md}            \emph{README for developers of this project.}\cr
#' ├─ \strong{R}                    \emph{Source code for use in this project.}\cr
#' └─ \strong{<NAME>.Rproj}         \emph{Rstudio project file.}\cr
#'
#' @param name Project
#' @param title "What the Project Does (One Line, Title Case)"
#'              If NULL, a random one will be generated.
#' @param folder Folder under which to create the project
#' @param packagedeps Set a tool for package reproducibility. Check valid options with \link{okpackagedeps}.
#' @param git Configure Git
#' @param external_setup How to do the partly interactive setup
#'  of online git, CI and coverage platforms. If NULL, no setup.
#'  \itemize{
#'  \item \code{git_service} Only "GitHub" is supported at the moment.
#'  \item \code{login} username or organization name to use for the git service.
#'                If NULL, no GitHub repo is created.
#'  \item \code{private} whether to make the created repo private
#'  \item \code{protocol} "ssh" or "https", protocol to use for GitHub
#'  \item \code{ci_activation} Only NULL, and "travis" are supported at the moment.
#'  "travis" means calling \code{usethis::use_travis()} and adding the Travis
#'  badge to the README.
#'  }
#' @param reset whether to reset the project to current project
#'
#' @export
#'
#' @examples
#' \dontrun{
#' folder <- tempdir()
#' createBasicProject(name = "doggos", title = "Counting cute dogs",
#'                    folder = folder,
#'                    packagedeps = "none",
#'                    git = TRUE, external_setup = NULL,
#'                    reset = TRUE)
#' list.files(file.path(folder, "doggos"))
#' unlink(file.path(folder, "doggos"))
#' }
createBasicProject <- function(name,
                               title = NULL,
                               folder = getwd(),
                               packagedeps = "packrat",
                               git = TRUE,
                               external_setup = NULL,
                               reset = TRUE) {

  packagedeps <- match.arg(packagedeps, okpackagedeps())

  # random title if needed
  if(is.null(title)){
    title <- cool_stuff()
  }

  # for later resetting the project
  current_proj <- get_current_proj()

  tryCatch({
      # create folder
      dir.create(file.path(folder, name))

      # set the active project to that folder
      usethis::proj_set(file.path(folder, name),
                        force = TRUE)

      # create the project
      usethis::create_project(file.path(folder, name),
                              open = FALSE,
                              rstudio = TRUE)

      # add DESCRIPTION file and fill title
      usethis::use_description()
      desc::desc_set("Title", title,
                     file = usethis::proj_get())


      # setup system for dependencies management
      setup_dep_system(packagedeps)

      # add README
      usethis::use_readme_md(open = FALSE)

      # git setup
      if (git){
        usethis::use_git(message = cool_first_commit())
      }

      if (!is.null(external_setup)){
        setup_repo(
          name = name,
          title = title,
          git_service = external_setup$git_service,
          login = external_setup$login,
          private = external_setup$private,
          protocol = external_setup$protocol,
          ci_activation = external_setup$ci_activation)
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
  if(reset){
    reset_proj(current_proj)
  }

  invisible(TRUE)
}
