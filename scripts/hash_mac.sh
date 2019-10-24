#!/bin/bash

digest="$1"
data="$2"
key="$3"
shift 3
echo -n "$data" | openssl dgst "-$digest" -hmac "$key" "$@"



# hex output by default
#hash_hmac "sha1" "value" "key"

# raw output by adding the "-binary" flag
#hash_hmac "sha1" "value" "key" -binary | base64

# other algos also work
#hash_hmac "md5"  "value" "key"
