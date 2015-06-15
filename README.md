Neo4j Import Fun
----------------

Import all the addresses in New Zealand.  Chur bro!

Dependencies:

* [New Zealand Street Address Electoral Dataset](https://data.linz.govt.nz/layer/779-nz-street-address-electoral/)
* [Neo4j](http://neo4j.com) 2.2.2 or greater, in a _neo4j_ directory


Usage
-----

```
make destroy-all-data
make load_csv
make query
```

OR 

```
./neo4j/bin/neo4j stop
rm -rf neo4j/data/graph.db
make import_tool
./neo4j/bin/neo4j start
make constraints
make query

```
