#!/bin/bash

cd ./image-ingest-worker/projects/ingest-worker-project/irisdemo-base-banksim
git pull
cd ..
git add irisdemo-base-banksim
git commit -m "Updated Ingestion Worker to use new master HEAD of irisdemo-base-banksim."
git push