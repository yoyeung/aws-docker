FROM anapsix/alpine-java:8_server-jre

RUN apk update
RUN apk add nodejs unzip wget

RUN npm install -g serverless yarn


# Create working space
RUN mkdir /var/dynamodb_wd
RUN mkdir /var/dynamodb_local
WORKDIR /var/dynamodb_wd

# Project working space
RUN mkdir /var/workspace


# Default port for DynamoDB Local
EXPOSE 7777

#for WEB
EXPOSE 3000
EXPOSE 3001
EXPOSE 3002

# Get the package from Amazon
RUN wget -O /var/dynamodb_wd/dynamodb_local_latest https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz
RUN tar xfz /var/dynamodb_wd/dynamodb_local_latest

# Default command for image
ENTRYPOINT ["java", "-Djava.library.path=./DynamoDBLocal_lib", "-jar", "DynamoDBLocal.jar","-dbPath", "/var/dynamodb_local"]
CMD ["-sharedDb","-port", "7777"]

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["/var/dynamodb_local","/var/workspace"]
