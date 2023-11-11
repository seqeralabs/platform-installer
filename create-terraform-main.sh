#!/usr/bin/env bash
source settings.sh
cat main.template.tf | envsubst > main.tf
