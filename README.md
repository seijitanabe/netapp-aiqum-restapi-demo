# netapp-aiqum-restapi-demo
- This is the repository for the NetApp Active IQ Unified Manager REST API (AIQUM) demo

## Prerequisites
- You need to execute the shell scripts in a linux host that installed `curl` and `jq`.
- How to install `curl` (CentOS/RHEL)
```
yum -y install curl
```
- How to install `jq` (CentOS/RHEL)
```
yum -y install epel-release
yum -y install jq
```

## Shell Scripts
### aiqum_create_file_share.sh
- You can provision a volume via AIQUM REST API.

### aiqum_clone_via_api_gateway.sh
- You can clone a volume via AIQUM REST API (using the API Gateway).
