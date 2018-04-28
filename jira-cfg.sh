# Set variables
SVRCONFIGLOC=${JIRA_INSTALL}/conf
SERVERFILE=${SVRCONFIGLOC}/server.xml

# SSL Termination config
if [[ -n "${ssl_term_domain}" ]] ; then
    # Build proxy info
    PROXYNAME=${ssl_term_domain}
    PROXYPORT="443"
    SCHEME="https"

    var_name="PROXY"
    var_value="proxyName=\"${PROXYNAME}\" \nsecure=\"true\" \nproxyPort=\"${PROXYPORT}\" \nscheme=\"${SCHEME}\""
    declare "$var_name=$var_value"

    ##
    # Insert proxy info
    # The result of the awk should look similar to the following
    # where proxyName is replaced with ${PROXYNAME} variable:
    ########
    ##    proxyName="jira.kadima.solutions"      -- Added by this script
    ##    secure="true"                          -- Added by this script
    ##    proxyPort="443"                        -- Added by this script
    ##    scheme="https"                         -- Added by this script
    ##    redirectPort="8443"                    -- Already present in file
    ########

    awk -v "var=${PROXY}" '/redirectPort/ && !x {print var; x=1} 1' ${SERVERFILE} > /tmp/tmp.xml && cp /tmp/tmp.xml ${SERVERFILE}
fi

# Import LDAP Cert, if the path is provided in Rancher as an environment variable. This will only be necessary for Jira to connect to Active Directory, since it is the central user stpore
if [[ -n "${ldap_cert}" ]] ; then
    keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${ldap_cert} -alias ldap_cert
fi

# Import the root certificates, if the path is provided in Rancher as an environment variable. These certificates are for the Atlassian site URLs, so that the application links function
if [[ -n "${AUX_ROOT_CERT_1}" ]] ; then
    keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_ROOT_CERT_1} -alias AUX_ROOT_CERT_1
fi

if [[ -n "${AUX_ROOT_CERT_2}" ]] ; then
    keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_ROOT_CERT_2} -alias AUX_ROOT_CERT_2
fi

if [[ -n "${AUX_ROOT_CERT_3}" ]] ; then
    keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_ROOT_CERT_3} -alias AUX_ROOT_CERT_3
fi

if [[ -n "${AUX_ROOT_CERT_4}" ]] ; then
    keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_ROOT_CERT_4} -alias AUX_ROOT_CERT_4
fi

if [[ -n "${AUX_ROOT_CERT_5}" ]] ; then
    keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_ROOT_CERT_5} -alias AUX_ROOT_CERT_5
fi



# Import the intermediate certificates, if the path is provided in Rancher as an environment variable. These certificates are for the Atlassian site URLs, so that the application links function, along with other app-to-app communication

if [[ -n "${AUX_INTER_CERT_1}" ]] ; then
	keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_INTER_CERT_1} -alias AUX_INTER_CERT_1
fi

if [[ -n "${AUX_INTER_CERT_2}" ]] ; then
	keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_INTER_CERT_2} -alias AUX_INTER_CERT_2
fi

if [[ -n "${AUX_INTER_CERT_3}" ]] ; then
	keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_INTER_CERT_3} -alias AUX_INTER_CERT_3
fi

if [[ -n "${AUX_INTER_CERT_4}" ]] ; then
	keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_INTER_CERT_4} -alias AUX_INTER_CERT_4
fi

if [[ -n "${AUX_INTER_CERT_5}" ]] ; then
	keytool -noprompt -importpass -storepass changeit -importcert -keystore ${JAVA_HOME}/jre/lib/security/cacerts -file ${AUX_INTER_CERT_5} -alias AUX_INTER_CERT_5
fi

