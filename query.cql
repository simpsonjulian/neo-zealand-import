RETURN "ALL THE DANNEVIRKES"
match (address:Address)-[:TOWN]-(town:Locality {name: 'Dannevirke'}) return count(address);
