#!/bin/bash

###
# Подсчитываем количество документов в коллекции
###

printf "mongos\n"
docker compose exec -T mongos mongosh --port 27017 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

###
# Подсчитываем количество документов в коллекции каждого из шардов
###

printf "\n\nshard1\n"
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

printf "\n\nshard2\n"
docker compose exec -T shard2 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
