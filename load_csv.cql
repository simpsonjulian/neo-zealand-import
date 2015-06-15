CREATE INDEX ON :Address(id);
CREATE INDEX ON :Locality(name);
CREATE INDEX ON :Authority(name);

MERGE (:Country {name: 'New Zealand'});

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM 'file:///tmp/nz-street-address-electoral.csv' AS line
CREATE (address:Address {id: line.id, text: line.address});

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM 'file:///tmp/nz-street-address-electoral.csv' AS line
MERGE (locality:Locality {name: line.locality});

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM 'file:///tmp/nz-street-address-electoral.csv' AS line
MERGE (ta:Authority {name: line.territorial_authority});

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM 'file:///tmp/nz-street-address-electoral.csv' AS line
CREATE (address:Address {id: line.id})-[:TOWN]->(locality:Locality {name: line.locality})-[:CITY]->(ta)-[:COUNTRY]->(:Country {name: 'New Zealand'});
