FROM          amazon/aws-cli
COPY          mongo.repo /etc/yum.repos.d/mongo.repo
RUN           yum install jq mongodb-org-shell git mysql -y
COPY          run.sh /
ENTRYPOINT    [ "bash", "-x", "/run.sh"]