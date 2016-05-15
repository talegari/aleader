### benchmark
--------------------------------------------------------

##### aleader
-- a streaming leader algorithm implementation in R

> license
* GNU Affero General Public License v3.0
* http://www.gnu.org/licenses/agpl-3.0.txt

hosted at : https://github.com/talegari/aleader

--------------------------------------------------------

| Spec     | Detail                                        |
|----------|-----------------------------------------------|
| file     | ratings.dat                                   |   
| filesize | 259 MB                                        |
| dataset  | MovieLens 10M Dataset                         |              
| link     | http://grouplens.org/datasets/movielens/10m/  |
| system   | Windows 7                                     |
| R        | R version 3.2.3 (2015-12-10)                  |
| spec     | 8 GB RAM, 1.7 Ghz                             |
| time     | 50 minutes                                    |
| memory   | 60 MB (consumed during the program run)       |
| cores    | 1                                             |

--------------------------------------------------------

##### How to benchmark on your machine ?

* Download `MovieLens 10M Dataset` from the link above and uncompress it.
* Copy the `ratings.dat` file to your working directory(*)
* Download these scripts to your working directory:
    * `benchmark_aleader.R`
    * `aleader.R`
    * `distance_functions.R`
* Install the required packages:
    * `asserthat`
    * `YaleToolkit` (for windows OS only)
* run the command: `Rscript benchmark_aleader.R`

(*) To find out the working diretory of R, type: `getwd()`

--------------------------------------------------------
