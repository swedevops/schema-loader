git clone https://github.com/swedevops/${COMPONENT}
cd $COMPONENT

if [ "$SCHEMA_TYPE" == "mongo" ]; then
  DOCDB_ENDPOINT=$(aws ssm get-parameters  --names prod.docdb.db_endpoint --with-decryption | jq .Parameters[].Value | sed -e 's/"//g')
  DOCDB_USER=$(aws ssm get-parameters  --names prod.docdb.db_user --with-decryption | jq .Parameters[].Value | sed -e 's/"//g')
  DOCDB_PASS=$(aws ssm get-parameters  --names prod.docdb.db_pass --with-decryption | jq .Parameters[].Value | sed -e 's/"//g')
  curl -L https://truststore.pki.rds.amazonaws.com/us-east-1/us-east-1-bundle.pem -o rds-combined-ca-bundle.pem
  mongo --ssl --host ${DOCDB_ENDPOINT}:27017 --sslCAFile rds-combined-ca-bundle.pem --username ${DOCDB_USER} --password ${DOCDB_PASS} <schema/${COMPONENT}.js

fi

if [ "$SCHEMA_TYPE" == "mysql" ]; then

  RDS_ENDPOINT=$(aws ssm get-parameters  --names prod.rds.db_host --with-decryption | jq .Parameters[].Value | sed -e 's/"//g')
  RDS_USER=$(aws ssm get-parameters  --names prod.rds.db_user --with-decryption | jq .Parameters[].Value | sed -e 's/"//g')
  RDS_PASS=$(aws ssm get-parameters  --names prod.rds.db_pass --with-decryption | jq .Parameters[].Value | sed -e 's/"//g')
  mysql -h ${RDS_ENDPOINT}  -u${RDS_USER} -p${RDS_PASS} < schema/${COMPONENT}.sql
fi

