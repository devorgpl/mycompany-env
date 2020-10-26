#!/bin/bash

## 1 start services

# docker-compose up -d

## wait until ready

# sleeep 60

## add admin user
export EXEC_KC="docker-compose exec -w /opt/jboss/keycloak/bin keycloak"
# docker-compose exec -w /opt/jboss/keycloak/bin keycloak ./add-user-keycloak.sh -r master -u devadmin -p devadmin
# docker-compose restart keycloak
# sleep 60

## login user
${EXEC_KC} ./kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user devadmin --password devadmin

## create dev realm
${EXEC_KC} ./kcadm.sh create realms -s realm=my-company -s enabled=true

${EXEC_KC} ./kcadm.sh create roles -r my-company -s name=website-access -s 'description=Website user'

## create app client
${EXEC_KC} ./kcadm.sh create clients -r my-company \
  -s clientId=website-client \
  -s enabled=true \
  -s publicClient=true \
  -s 'redirectUris=["https://mf.net.pl/*"]' \
  -s baseUrl=https://mf.net.pl/

## add role as default
export EXEC_KC_D="docker exec -i -w /opt/jboss/keycloak/bin dev_keycloak_1 "
echo '{ "realm": "my-company", "enabled": true, "defaultRoles" : [ "offline_access", "uma_authorization", "website-access" ], '\
  '"registrationAllowed" : true, "registrationEmailAsUsername" : true, "rememberMe" : true, "verifyEmail" : false, "loginWithEmailAllowed" : true, "duplicateEmailsAllowed" : false,'\
  '"resetPasswordAllowed" : true, "editUsernameAllowed" : false, "bruteForceProtected" : false }' | ${EXEC_KC_D} ./kcadm.sh update realms/my-company -f -

${EXEC_KC} ./kcadm.sh create users -r my-company \
  -s username=testuser \
  -s enabled=true

${EXEC_KC} ./kcadm.sh set-password -r my-company --username testuser --new-password testpassword
${EXEC_KC} ./kcadm.sh get-roles -r my-company --uusername testuser
${EXEC_KC} ./kcadm.sh add-roles --uusername testuser --rolename website-access -r my-company
${EXEC_KC} ./kcadm.sh create groups -r my-company -s name=WebuserGroup
${EXEC_KC} ./kcadm.sh add-roles -r my-company --gname WebuserGroup --cclientid website-client --rolename website-access
