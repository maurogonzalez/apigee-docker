# Apigee Edge Docker 5-node installation

## Overview
This projects installs and runs a 5-node [Apigee Edge for Private Cloud 4.17.09](https://docs.apigee.com/private-cloud/latest/overview) 
with Developer Services portal using docker containers for testing purposes only. 

Optionally you can install [Saml on Edge](https://docs.apigee.com/private-cloud/latest/supporting-saml-edge-private-cloud). 

The steps of the _docker-composer.yml_ could be used as a guide for the installation. 
Please note the [wait-for-it](https://github.com/vishnubob/wait-for-it) commands that enforce 
the containers to be ran in the correct order.

To see a complete list of system requirements, OS settings, supported software and full installation steps
please refer to the [Official Documentation](https://docs.apigee.com/private-cloud/latest/installing-edge-private-cloud).

## Requirements
- docker >= 17.05.0-ce
- docker-compose >= 1.11.2

## Description
- Builds an Apigee 4.17.09 image with the **apigee-setup-utility** that will run Centos7 with OpenJDK 1.8.

- Installs 5-node Apigee Edge planet and Developer portal:
  - node1:
      - ZK, CS, OpenLDAP, MS and UI.
  - node2:
      - ZK, CS and RMP.
  - node3:
      - ZK, CS and RMP.
  - node4:
      - PS, PG master, QS and QPID.
  - node5:
      - PS, PG standby, QS and QPID.
  - node6:
      - Developer Services portal .
- Provision with an organization and an environment.

## Usage

### Fresh install
1. Set `.env` file: 
    - ADMIN_USER: MS admin user and OrgAdmin user. 
    - ADMIN_PWD: MS admin user, OpenLDAP password and Org Admin user.
    - ORG: organization name used in the provisioning.
    - ORG_ENV: environment name used in the provisioning.
2. Build the Apigee base image. This will create a local Docker image with the **apigee-setup utility**:
    - Run `./build_apigee_base.sh`. 
    - This will ask for your apigee credentials (software.apigee.com) and the path of the license (this should be in the project folder).
3. Install and run the 5-node planet:
    - Run `docker-compose up`.
    - This could take several minutes depending on your internet bandwidth and hardware.

### Start Apigee Edge 
- Run `docker-compose up`

### Stop Apigee Edge
- Run `docker-compose stop`

### Test your installation:
- Edge UI: http://10.5.0.2:9000
- MS API: http://10.5.0.2:8080/v1
- DevPortal: http://10.5.0.7:8079 
- Proxy Endpoint: 
  - Router on node 2: http://10.5.0.3:9001/{PROXY_BASE_PATH}
  - Router on node 3: http://10.5.0.4:9001/{PROXY_BASE_PATH}

### SAML for Edge
1. Configure your [Okta](https://www.okta.com/) account with:
    - Single sign on URL: http://10.5.0.2:9099/saml/SSO/alias/apigee-saml-login-opdk
    - Audience URI: apigee-saml-login-opdk
    - SAML Issuer ID (Show Advanced Settings): okta
2. Modify **.env** and set **SSO_METADATA_URL** to the given Metadata URL.
3. Access MS:
    - `docker exec -it docker_apigee_node1_1 bash`, or
    - `docker exec -it docker_apigee_node1_1 {COMMAND}`

4. Configure SSO:
    - `/opt/apigee/apigee-setup/bin/setup.sh -p sso -f /tmp/apigee/response-sso.txt`
5. Enable SSO in Edge UI:
    - `/opt/apigee/apigee-service/bin/apigee-service edge-ui configure-sso -f /tmp/apigee/response-sso.txt`

**NOTE:**
- Please take a look into 
  [Edge Users with SSO](https://docs.apigee.com/private-cloud/latest/register-new-edge-users)
  before enabling SSO.


## Troubleshooting
List running containers:
  - `docker ps -f "name=docker_apigee*"`

List existing containers:
  - `docker ps -a -f "name=docker_apigee*"`

Access a running container:
  - `docker exec -it docker_apigee_node{NODE_NUMBER}_1 bash`
  
Run a command inside a running container:
  - `docker exec -it docker_apigee_node{NODE_NUMBER}_1 {COMMAND}`

## Remove docker containers
Remove containers:
  - Single container: `docker rm {DOCKER_CONTAINER_ID}`
  - All containers: `docker rm $(docker ps -aq -f "name=docker_apigee*)`

Remove docker volumes:
  - `docker volume rm $(docker volume ls -q -f "name=docker_apigee*")`

## NOTES
- This will have your apigee license so **DO NOT** push it to a public docker registry.
- This is only for testing **DO NOT** use in production.

## References
- [Apigee](https://apigee.com/api-management/#/homepage)
- [Apigee for Private Cloud](https://docs.apigee.com/private-cloud/latest/overview)
- [Docker](https://www.docker.com/)
- [wait-for-it](https://github.com/vishnubob/wait-for-it)
- [Okta](https://www.okta.com/)

## Author

If you have any questions regarding this project contact:  
Mauro González <jmajma8@gmail.com>
