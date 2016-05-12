## *aleader*
> * a streaming `leader-follower` algorithm implementation in [R](http://r-project.org)
> * To facilitate clustering large datasets
> * License: [GNU Affero General Public License v3.0](http://www.gnu.org/licenses/agpl-3.0.txt)
> * Hosted at: https://gist.github.com/talegari

#### Algorithm

* Radius of a cluster is  pre-set.
* Data is read in streaming fashion.
* First data point is assigned to a cluster(The cluster centroid happens to be the point itself).
* For each subsequent data point:
	* we compute the distance between it and every cluster centroid.
	* If the minimum of those diatances $\le$ radius, we assign the point to the closest cluster and recompute the cluster centroid.
	* Else, we assign the point to a new cluster.
	* Note that, most of the implemenations of `leader-follower`, do not compute cluster centroids. For each subsequent data point, the distance between it and the leader(first point added to the cluster)is computed.

#### Implementation details

* A file is read via a file connection one line at a time. Hence, the whole data is **not** loaded at a time into RAM.
* We assume that each line forms a numeric vector(array) of same length.
* The cluster number is written a to a file as soon as a line is processed (A different process may read the file and perhaps plot it).
* Once all the lines are processed, a summary is written to the screen containing :
	* `number_of_clusters`
	* `centroids`
	* `cluster_sizes`

#### Example

```R
source("aleader.R")
dist_env = new.env()
sys.source("distance_functions.R", envir = dist_env)

write.table(iris[,1:4]
            , file = "iris.txt"
            , row.names = FALSE
            , sep = ","
            )

leader(filename = "iris.txt"
       , output = "iris_leader.txt"
       , radius = 2.5
       , distance_function = dist_env[['dist_euclidean']]
       )

result = unlist(read.csv("iris_leader.txt")[[1]])
result
pr     = prcomp(iris[,1:4])$x

# visualize the clusters
plot(pr[,1],pr[,2], col = result)

# cleanup
unlink("iris.txt")
unlink("iris_leader.txt")
rm(pr, result, dist_env, leader)
```

#### Benckmarks on large datasets

See [benchmark](https://github.com/talegari/aleader/blob/master/benchmark.md) file

#### License

[GNU Affero General Public License v3.0](http://www.gnu.org/licenses/agpl-3.0.txt)

----



