# benchmark_aleader.R
# benchmark the `aleader` function on `ratings.dat` dataset.
# Read `benchmarks.md` for further details.


#--------------------------------------------------------
# aleader
# -- a streaming leader algorithm implementation in R
#
# > license
# * GNU Affero General Public License v3.0
# * http://www.gnu.org/licenses/agpl-3.0.txt
#
# hosted at : https://gist.github.com/talegari
#
# --------------------------------------------------------

cat("\n***************************************************************")
cat("\nscript to benchmark aleader")
cat("\n***************************************************************\n")
source("aleader.R")
source("distance_functions.R")

invisible(gc(reset = TRUE))
start_mem = sum(gc()[,6])
cat("\nMemory usage at the beginning (in MB): ", start_mem, "\n")

start_time = Sys.time()
cat("\nStart time: ")
print(start_time)

cat("\nRunning function ...\n")

leader(filename = "ratings.dat"
       , output = "ratings_output.txt"
       , radius = 10^8
       , distance_function = 'dist_euclidean'
       , sep = "::"
       )

end_time = Sys.time()
cat("\nend time: ")
print(end_time)
cat("\ntime elapsed: ", end_time - start_time, "\n")

max_mem = sum(gc()[,6])
cat("\nMaximum memory usage during the function run(in MB): ", max_mem, "\n")
cat("\nDifference: \n", max_mem - start_mem)
cat("\n***************************************************************\n")
