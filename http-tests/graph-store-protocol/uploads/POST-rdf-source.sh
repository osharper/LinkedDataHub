#!/bin/bash

initialize_dataset "$END_USER_BASE_URL" "$TMP_END_USER_DATASET" "$END_USER_ENDPOINT_URL"
initialize_dataset "$ADMIN_BASE_URL" "$TMP_ADMIN_DATASET" "$ADMIN_ENDPOINT_URL"
purge_backend_cache "$END_USER_VARNISH_SERVICE"
purge_backend_cache "$ADMIN_VARNISH_SERVICE"

pushd . > /dev/null && cd "$SCRIPT_ROOT/admin/acl"

# add agent to the writers

./add-agent-to-group.sh \
  -f "$OWNER_CERT_FILE" \
  -p "$OWNER_CERT_PWD" \
  --agent "$AGENT_URI" \
  "${ADMIN_BASE_URL}acl/groups/writers/"

popd > /dev/null

pushd . > /dev/null && cd "$SCRIPT_ROOT"

# create container

slug="test"

graph=$(./create-container.sh \
-f "$AGENT_CERT_FILE" \
-p "$AGENT_CERT_PWD" \
-b "$END_USER_BASE_URL" \
--title "Test" \
--slug "$slug" \
--parent "$END_USER_BASE_URL")

# import RDF from source URI

source="http://dig.csail.mit.edu/2008/webdav/timbl/foaf.rdf"

echo "Importing RDF from source: $source"

rdf_post+="-F \"rdf=\"\n"
rdf_post+="-F \"sb=arg\"\n"
rdf_post+="-F \"pu=http://purl.org/dc/terms/source\"\n"
rdf_post+="-F \"ou=${source}\"\n"
rdf_post+="-F \"pu=http://www.w3.org/ns/sparql-service-description#name\"\n"
rdf_post+="-F \"ou=${graph}\"\n"

# POST RDF/POST multipart form from stdin to the server
echo -e "$rdf_post" \
| curl -w "%{http_code}\n" -v -k -D - --config - \
  -E "$AGENT_CERT_FILE":"$AGENT_CERT_PWD" \
  -H "Accept: text/turtle" \
  "${END_USER_BASE_URL}clone" \
| grep -q "$STATUS_OK"

pushd . > /dev/null && cd "$SCRIPT_ROOT"

doc_ntriples=$(./get-document.sh \
  -f "$AGENT_CERT_FILE" \
  -p "$AGENT_CERT_PWD" \
  --accept 'application/n-triples' \
  "${END_USER_BASE_URL}service?graph=${graph}")

popd > /dev/null

# check that the graph has been imported and contains the right triples

echo "$doc_ntriples" | grep "<http://dig.csail.mit.edu/2008/webdav/timbl/foaf.rdf> <http://xmlns.com/foaf/0.1/maker> <http://www.w3.org/People/Berners-Lee/card#i>"