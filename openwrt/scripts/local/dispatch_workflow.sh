#!/usr/bin/env bash

BRANCH="master"

[ -z "${GITHUB_TOKEN}" ] && echo "Please 'export GITHUB_TOKEN='" && exit 1

# Get latest run of workflow off master
# run_id == id here not run_number :/
WORKFLOW_ID=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" \
              -H "Accept: application/vnd.github.v3+json" \
              https://api.github.com/repos/socallinuxexpo/scale-network/actions/workflows | jq '.workflows | .[] | select( (.path == ".github/workflows/openwrt-build.yml")) | .id')
# TODO: USE \/\/
#curl -H "Authorization: Bearer $GITHUB_TOKEN" \
#              -X POST \
#              -H "Accept: application/vnd.github.v3+json" \
#              https://api.github.com/repos/socallinuxexpo/scale-network/actions/workflows/${WORKFLOW_ID}/dispatches \
#              -d '{"ref":"master"}'


# Have to use something like this to fine runs
#curl -H "Authorization: Bearer $GITHUB_TOKEN" \
#              -H "Accept: application/vnd.github.v3+json" \
#              https://api.github.com/repos/socallinuxexpo/scale-network/actions/runs
POLL WORKFLOW = <something> | jq '.workflow_runs | .[] |  select( (.workflow_id == 11550084) and (.status == "in_progress") and (.head_branch == "master") and (.event == "workflow_dispatch"))'

exit 100
