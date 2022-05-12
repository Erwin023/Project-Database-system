
library(RPostgres)

con <- dbConnect(RPostgres::Postgres(), dbname = "zoo",
                 host = "localhost", port = 5432,
                 user = "projekt", pass = "Pr20bd")