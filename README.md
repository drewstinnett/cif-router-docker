# CIF-Router Docker

This is meant to be a minimal container to run only the cif-router code.
Currently this only works with the elasticsearch storage method in CIF

## Local Testing

You can use the included `docker-compose.yaml` to test out functionality, and
get a feel for other containers that will be needed here

## Origin

Originally used the [sfinlon/cif-docker](https://github.com/sfinlon/cif-docker)
image, however I was needing to make a ton of changes to get it working in a
way that k8s/okd would like.  Hoping to contribute it back once I've got all
the pieces in place

This image differs from the above image in a few key ways:

* Only runs the CIF router.  Other pieces will need to be run on their own
  (GeoIP, SMRT, httpd, etc)

* Runs as non root user

* All configuration should be set at container runtime, instead of build time
