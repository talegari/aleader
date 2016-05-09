# distance functions

dist_euclidean = function(vec1, vec2){
  return ( sqrt(sum((vec1 - vec2)^2)) )
}

dist_manhattan = function(vec1, vec2){
  return( sum(abs(vec1 - vec2)) )
}

dist_min = function(vec1, vec2){
  return( min(abs(vec1 - vec2)) )
}

dist_max = function(vec1, vec2){
  return( max(abs(vec1 - vec2)) )
}

dist_minkowski = function(vec1, vec2, power){
  return ( (sum((vec1 - vec2)^power))^(1/power) )
}
