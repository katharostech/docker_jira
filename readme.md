# Build the version specific image
Building this image requires that you pass a version of the JIRA binary to the build command.  This version must coincide directly with the build number that resides in the downloads section of BitBucket for this Git repo.

```bash
docker build --build-arg JIRA_VERSION=7.9.1 -t kadimasolutions/jira:7.9.1 .
```

# Run the container
Running the container can be done as follows.  Take note that if any of the "db" environment variables are missing from the run command of this container, the container will assume that this is a new instance and it will treat it as such.  You will be presented with the default installation wizard when navigating to the site. If this site will sit behind a reverse proxy for SSL Termination, you will need to provide the domain in the "ssl_term_domain" environment variable. Simply omit this variable if it does not apply to your instance. This feature was added since SSL termination is not handled by JIRA out-of-the-box, and additional config must be addressed accordingly.

```bash
docker run -h jira \
--name jira \
-e dbhost="mydbhost" \
-e dbport="3306" \
-e dbname="mydb" \
-e dbuser="mydbuser" \
-e dbpass="mydbpass" \
-e ssl_term_domain="jira.kadima.solutions" \
-p 80:8080 \
-dt kadimasolutions/jira:7.9.1
```
