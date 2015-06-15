match (address:Address)-[:TOWN]-(town:Locality {name: 'Dannevirke'}) return count(address);
