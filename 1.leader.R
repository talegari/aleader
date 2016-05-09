# leader
#
# a streaming leader algorithm implementation in R ----
#
# Description ----
#
# One line is read at a time from a file. The point is assigned to the
# closest cluster centroid if distance <= radius. Else, it is assigned to
# a new cluster. And cluster centroids are recomputed.
#
# Arguments ----
#
# filename          : file(string) to be processed  where each line is
#                     is essentially a numeric vector (string)
# output            : file(string) where cluster numbers
#                     are written on each line
# radius            : (a positive numeric)
# distance_function : a function which takes two numeric vectors and
#                     returns a numeric. Defaults to "dist_euclidean"
# ignoreColumns     : integer vector of the column numbers to be ignored.
#                     Defaults to NULL
# header            : boolean defaults to TRUE
# sep               : separator defaults to ","
# call_gc_after     : frequency of gc call in terms of lines
#                     (positive integer). Defaults to 1000
#
# Imports/Depends ----
#
# R(version >=3)
# unix based system (for `wc` call)
#
# Example ----
#
# source("leader.R")
# dist_env = new.env()
# sys.source("distance_functions.R", envir = dist_env)
#
# write.table(iris[,1:4]
#             , file = "iris.txt"
#             , row.names = FALSE
#             , sep = ","
#             )
#
# leader(filename = "iris.txt"
#        , output = "iris_leader.txt"
#        , radius = 2.5
#        , distance_function = dist_env[['dist_euclidean']])
#
# result = unlist(read.csv("iris_leader.txt")[[1]])
# pr     = prcomp(iris[,1:4])$x
#
# # visualize the clusters
# plot(pr[,1],pr[,2], col = result)
#
# # cleanup
# unlink("iris.txt")
# unlink("iris_leader.txt")
# rm(pr, result, dist_env, leader)
#
# Author ----
# Srikanth KS (talegari)
# sri dot teach at gmail dot com
#

leader = function(filename
                  , output
                  , radius
                  , distance_function = "dist_euclidean"
                  , ignoreColumns = NULL
                  , header        = TRUE
                  , sep           = ","
                  , call_gc_after = 1000){

  # set distance function
  dist_fun = match.fun(distance_function)
  # read connection
  read_conn  = file(filename, "r")
  on.exit(close(read_conn), add = TRUE)
  # write connection
  write_conn = file(output, "w")
  on.exit(close(write_conn), add = TRUE)

  # number of lines of the file
  nol = function(f){
    wcString <- system(paste0("wc -l ", f), intern = TRUE)
    return( as.integer(strsplit(wcString, " ")[[1]][1]) )
  }
  n_lines    = nol(filename)

  # function to update the centroid
  update_centroid = function(centroid, size, avec){
    return ( ((centroid*size) + avec)/(size + 1) )
  }

  # move the line pointer to first valid line
  if(header){
    firstLine = readLines(read_conn,1)
    rm(firstLine)
    n_lines   = n_lines - 1
  }

  # set up for the first valid line only
  aline   = readLines(read_conn,1)
  avec    = as.numeric(trimws(strsplit(aline, sep)[[1]]))
  if(!is.null(ignoreColumns)){
    avec    = avec[-ignoreColumns]
  }
  cenMat  = matrix(avec, nrow = 1)
  sizeVec = c(1)
  writeLines(as.character(1), con = write_conn)

  # loop over each line and update
  for(line_number in 2:n_lines){
    aline = readLines(read_conn,1)
    avec  = as.numeric(trimws(strsplit(aline, sep)[[1]]))
    if(!is.null(ignoreColumns)){
      avec    = avec[-ignoreColumns]
    }
    dists = apply(cenMat
                  , 1
                  , function(x){dist_fun(avec, x)}
                  )
    # add to an existing cluster
    if(min(dists) <= radius){
      cl_number = which.min(dists)
      writeLines(as.character(cl_number), con = write_conn)
      cenMat[cl_number,] = update_centroid(cenMat[cl_number,]
                                           , sizeVec[cl_number]
                                           , avec)
      sizeVec[cl_number] = sizeVec[cl_number] + 1
    } else {
      # form a new cluster
      writeLines(as.character(length(sizeVec) + 1), con = write_conn)
      cenMat = rbind(cenMat, avec)
      sizeVec[length(sizeVec) + 1] = 1
    }

    if(line_number %% call_gc_after == 0){
      invisible(gc())
    }
  }
  rownames(cenMat) = NULL
  return(list(number_of_clusters = length(sizeVec)
              ,centroids = cenMat
              , cluster_sizes = sizeVec))
}
