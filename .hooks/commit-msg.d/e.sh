#!/usr/bin/env bash

hook_type=${BASH_SOURCE##*/}

echo "Hello from $hook_type"