
/*CVE-2025-24493*/
DROP TABLE IF EXISTS cve;
CREATE TABLE cve(
    id SERIAL PRIMARY KEY ,
    cveid varchar(20) UNIQUE,
    published varchar(22) NOT NULL,
    name varchar(50) NOT NULL,
    jsondata json NOT NULL
);


CREATE TABLE temp_json (values text);
COPY temp_json FROM '/tmp/CVE-2025-20063.json';
COPY temp_json FROM '/tmp/CVE-2025-24493.json';
COPY temp_json FROM '/tmp/CVE-2025-25217.json';
COPY temp_json FROM '/tmp/CVE-2025-26693.json';


INSERT INTO cve(cveid,published,name,jsondata)  
SELECT values::json #>>'{cveMetadata,cveId}' as id,
       values::json #>>'{cveMetadata,datePublished}' as published,
       values::json #>>'{cveMetadata,assignerShortName}' as name,
       values::json as jsondata
FROM  temp_json;

/* DROP TABLE IF EXISTS temp_json;*/