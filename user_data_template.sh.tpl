
#!/bin/bash

# Download and extract Flyway
sudo wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/9.22.2/flyway-commandline-9.22.2-linux-x64.tar.gz | tar -xvz && sudo ln -s `pwd`/flyway-9.22.2/flyway /usr/local/bin

# Create a symbolic link to make Flyway accessible globally
sudo ln -s $(pwd)/flyway-9.22.1/flyway /usr/local/bin

# Create the SQL directory for migrations
sudo mkdir sql

# Download the migration SQL script from AWS S3
aws s3 cp s3://nest-sql/V1__nest.sql sql/

# Run Flyway migration
sudo flyway -url=jdbc:mysql="${rds_endpoint}/${rds_db_name}" \
  -user="${username}" \
  -password="${password}" \
  -locations=filesystem:sql \
  migrate

# Then shutdown after waiting 7 minutes
# sudo shutdown -h +7
