#!/bin/bash

# Stop JIRA gracefully
trap "{ /opt/atlassian/jira/bin/stop-jira.sh; exit $?; }" SIGTERM SIGINT

# Run dynamic config before starting
/jira-cfg.sh

# Start JIRA
su -c "/opt/atlassian/jira/bin/start-jira.sh -fg" jira &

# Loop until signal
while :
do
    sleep 4
done
