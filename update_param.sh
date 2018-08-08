#!/bin/sh

# Exit on failure of any command

set -e


curl -s -H 'Accept: application/vnd.go.cd.v6+json' -D headers -o pipeline 'http://localhost:8153/go/api/admin/pipelines/PipelineB'
ETAG=$(sed -n 's/^ETag: "\([^"]*\)".*/\1/p' headers)

echo $ETAG

# Make some change to the pipeline config. In this case, prepend "HOTFIX" to the label template.
sed -e 's/"label_template" : "/&'$release_type'-/' pipeline >pipeline.for_update

cat pipeline.for_update

curl -s -o pipeline.after_update -X PUT -H 'Content-Type: application/json' -H "If-Match: \"$ETAG\"" -H 'Accept: application/vnd.go.cd.v6+json' --data-binary @pipeline.for_update 'http://localhost:8153/go/api/admin/pipelines/PipelineB'

echo "Updated pipeline config is in the file pipeline.for_update"
