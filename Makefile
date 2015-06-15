nz-street-address-electoral.csv:
	unzip lds-nz-street-address-electoral-CSV.zip
	rm *.prj *.xml *.vrt *.txt

destroy-all-data:
	./neo4j/bin/neo4j stop
	rm -rf neo4j/data/graph.db
	./neo4j/bin/neo4j start

import: nz-street-address-electoral.csv
	cp -f nz-street-address-electoral.csv /tmp/
	./neo4j/bin/neo4j-shell -file import.cql

query:
	./neo4j/bin/neo4j-shell -file query.cql
