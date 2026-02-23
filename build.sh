#!/usr/bin/env bash
set -o errexit

mix deps.get --only prod
MIX_ENV=prod mix deps.compile
MIX_ENV=prod mix compile