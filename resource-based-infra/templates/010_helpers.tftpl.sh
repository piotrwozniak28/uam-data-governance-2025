gcloud auth application-default set-quota-project "${project_id}"

bq ls --project_id "${project_id}" --format=json | jq -r '.[].datasetReference.datasetId' | \
while read -r DATASET_ID; do
    echo "Processing dataset: ${project_id}:$${DATASET_ID}"
    bq ls --format=json "${project_id}:$${DATASET_ID}" | \
        jq -r '.[] | select(.type=="TABLE" or .type=="VIEW") | .id' | \
        while read -r OBJECT_ID; do
            echo "  Deleting: $${OBJECT_ID}"
            # For a dry run to see what WOULD be deleted, comment out the 'bq rm'
            # line below and uncomment the 'echo "  WOULD DELETE..." line.
            # echo "  WOULD DELETE: $${OBJECT_ID} (Dry Run)"
            bq rm -f --table "$${OBJECT_ID}"
        done
    # bq rm --project_id=${project_id} -r -f "$${DATASET_ID}"         
done
