#!/bin/bash
echo "Waiting for MongoDB to start..."
RETRIES=10
until mongosh --host mongodb-primary:27017 --eval "print('MongoDB is up')" > /dev/null 2>&1; do
  echo "Waiting for primary MongoDB connection..."
  sleep 3
  ((RETRIES--))
  if [ $RETRIES -le 0 ]; then
    echo "MongoDB did not start in time. Exiting."
    exit 1
  fi
done

echo "MongoDB is up, initiating replica set..."

mongosh --host mongodb-primary:27017 <<EOF
  var cfg = {
    "_id": "rs0",
    "version": 1,
    "members": [
      {
        "_id": 0,
        "host": "mongodb-primary:27017",
        "priority": 2
      },
      {
        "_id": 1,
        "host": "mongodb-secondary:27017",
        "priority": 0
      },
      {
        "_id": 2,
        "host": "mongodb-arbiter:27017",
        "priority": 0
      }
    ]
  };
  rs.initiate(cfg);
EOF