clean:
	rm -f *.csv

nz-street-address-electoral.csv:
	unzip lds-nz-street-address-electoral-CSV.zip
	rm *.prj *.xml *.vrt *.txt

destroy-all-data:
	./neo4j/bin/neo4j stop
	rm -rf neo4j/data/graph.db
	./neo4j/bin/neo4j start

load_csv: nz-street-address-electoral.csv constraints
	cp -f nz-street-address-electoral.csv /tmp/
	./neo4j/bin/neo4j-shell -file import.cql

constraints:
	./neo4j/bin/neo4j-shell -file constraints.cql

query:
	./neo4j/bin/neo4j-shell -file query.cql

locality.csv:
	grep -v '^id' nz-street-address-electoral.csv | awk -F ',' '{printf "%s,Locality\n",$$10}' | sort -u  > $@
	gsed -i 's/Auckland,Locality/Auckland Central,Locality/' $@
	sort -uo $@ $@

city.csv:
	grep -v '^id' nz-street-address-electoral.csv | awk -F ',' '{printf "%s,Authority\n",$$11}' | sort -u  > $@

addresses.csv:
	grep -v '^id' nz-street-address-electoral.csv | awk -F ',' '{printf "%s,%s,Address\n",$$2,$$5}' | sort -u  > $@

country.csv:
	echo 'New Zealand,Country' > $@

rels.csv:
	grep -v '^id' nz-street-address-electoral.csv  | awk -F ',' '{printf "%s,%s,TOWN\n%s,%s,CITY\n%s,%s,COUNTRY\n",$$2,$$10,$$10,$$11,$$11,"New Zealand"}' | sort -u  >> $@
	gsed -i 's/Auckland,TOWN/Auckland Central,TOWN/' $@
	gsed -i 's/Auckland,Auckland,CITY/Auckland Central,Auckland,CITY/' $@

import_tool:  nz-street-address-electoral.csv rels.csv addresses.csv locality.csv city.csv country.csv
	./neo4j/bin/neo4j-import -into neo4j/data/graph.db \
		--nodes headers/addresses.csv,addresses.csv \
	  --nodes headers/generic.csv,locality.csv \
	  --nodes headers/generic.csv,city.csv \
	  --nodes headers/generic.csv,country.csv \
		--relationships headers/rels.csv,rels.csv \
		--stacktrace
