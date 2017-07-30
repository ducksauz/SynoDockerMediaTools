# SynoDockerMediaTools
Docker and nginx configuration for running a selection of media tools and moinmoin on my Synology NAS

### Installation
* Create required paths for tool volume mounts on your NAS as noted in the docker-compose.yml file
* Run free80and443.sh to free up those ports on the NAS
* Run update-containers.sh to build/pull the containers and start them. Obviously, the docker-compose down call in there will fail the first time.
* Use update-containers.sh periodically to upgrade your containers.

### Notes

#### Using Ports 80 and 443
* Based on a comment from [this post](http://tonylawrence.com/post/unix/synology/freeing-port-80/), I created free80and443.sh. This will edit the DSM system nginx template files to change 80 to 81 and 443 to 444, freeing up those ports for use by the reverseproxy container. This will result in a security notice from DSM's security checks noting that DSM system files have been modified.

#### Certificate and TLS configuration
* The NAS systemwide default certificate is mapped into the reverseproxy container so a single update of the cert on the NAS via DSM will update the cert for the reverseproxy container too.
* HTTP on the reverseproxy container is a permanent redirect to HTTPS, as is right and proper.
* TLS configuration in the reverseproxy container is modern. Old browsers not supported.
* reverseproxy is a TLS mullet. Business (TLS) up front, party (clear text HTTP) in the back to the containers running the services. However, all the clear text HTTP to the services happens over Docker's internal virtual network and no clear text is exposed to the physical network. I consider this an acceptable security risk for something that runs on my home server.

#### Container Environment Variables
* TZ should be set to your appropriate timezone.
* PUID and PGID need to be set to the UID and GID of the user on the NAS that owns the config and data files that are volume mapped into the containers.

