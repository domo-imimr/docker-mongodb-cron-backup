FROM ubuntu:20.04

RUN apt-get update && apt-get -y install gnupg curl

RUN curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
    --dearmor

RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
# Reload local package database
RUN apt-get update
# Install the MongoDB packages
RUN apt-get install -y mongodb-org
# Install Cron
RUN apt-get -y install cron
# Making the crontab file based on env vars and put to the cron directory
COPY entrypoint.sh /
COPY cleanBackup.sh /
RUN chmod +x /entrypoint.sh
RUN chmod +x /cleanBackup.sh
ENTRYPOINT ["/entrypoint.sh"]

# Run the command on container startup
CMD ["cron", "-f"]
