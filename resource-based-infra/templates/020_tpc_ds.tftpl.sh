#!/bin/bash
# https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp
# https://temp-mail.org/

# https://chistadata.com/how-to-prepare-the-clickhouse-database-for-the-tpc-ds-benchmarking-part-i/
# https://stackoverflow.com/questions/75377874/many-multiple-definition-of-errors-shows-up-when-compiling-tpc-ds-tools
# https://github.com/gregrahn/tpcds-kit/issues/57

sudo add-apt-repository ppa:ubuntu-toolchain-r/ppa -y
sudo apt update
sudo apt install -y wget unzip make g++-9 gcc-9
gcloud storage cp gs://bkt-tpcds-seed-100-asd356y4h68f213/DSGen-software-code-4.0.0.zip . --billing-project=${project_id}
unzip "$${HOME}/DSGen-software-code-4.0.0.zip"
cd "$${HOME}/DSGen-software-code-4.0.0/tools/"
make CC=gcc-9
mkdir -p "$${HOME}/data/tpc_ds"
./dsdgen -scale 1 -dir "$${HOME}/data/tpc_ds" -TERMINATE N -parallel 2 -child 1
./dsdgen -scale 1 -dir "$${HOME}/data/tpc_ds" -TERMINATE N -parallel 2 -child 2
# watch -d 'ps -h'
# watch -d 'du -shc "$${HOME}/data/tpc_ds"'
cd "$${HOME}/data/tpc_ds"

tpcds_sort() {
    local _regex _file _dir_name _dry_run
    _dry_run=false

    if [[ "$1" == "--dry-run" ]]; then
        _dry_run=true
        echo "--- Dry Run Mode: Commands will be printed, not executed. ---"
        shift
    fi

    _regex="([a-z]+_?[a-z]+)[0-9a-z]*"; readonly _regex

    for _file in *.dat; do
        # If glob doesn't expand (no files found), _file will be the literal "*.dat"
        if [[ ! -e "$_file" ]]; then
            if [[ "$_file" == "*.dat" ]]; then # This specific check for the literal string
                echo "No .dat files found in the current directory."
            else
                echo "Warning: File '$_file' (from glob '*.dat') does not exist. Skipping."
            fi
            break 
        fi

        if [[ "$_file" =~ $_regex ]]; then
            _dir_name="$${BASH_REMATCH[1]}"
            if [[ "$_dry_run" == true ]]; then
                echo "mkdir -p \"$_dir_name\""
                echo "mv \"$_file\" \"$_dir_name/\""
            else
                mkdir -p "$_dir_name"
                mv "$_file" "$_dir_name/"
            fi
        else
             if [[ "$_dry_run" == true ]]; then
                echo "Skipping '$_file': does not match regex '$_regex'"
             fi
        fi
    done

    if [[ "$_dry_run" == true ]]; then
        echo "--- Dry Run Complete ---"
    fi
}

tpcds_sort
gcloud storage cp -r . gs://${bucket_name}
