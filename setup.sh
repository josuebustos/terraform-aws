#!/bin/bash


PRESIGN=$(aws s3 --profile default presign s3://nginx-conf-repo/dev1/nginx.conf --expires-in 604800) # 10 minutes

curl -o nginx.conf https://nginx-conf-repo.s3.us-east-1.amazonaws.com/dev1/nginx.conf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAZSJWSP4LGQIWQSUG%2F20220716%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220716T031421Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=1a62253fec4b6a71e6f0222ea48f74ea3d984898e48de00ddc23e4392624d384