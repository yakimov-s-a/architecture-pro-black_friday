#!/bin/bash

###
# Подсчитываем количество документов в коллекции через разные роутеры
###

printf "mongos-1\n"
docker compose exec -T mongos-1 mongosh --port 27017 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

printf "\n\nmongos-2\n"
docker compose exec -T mongos-2 mongosh --port 27017 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

###
# Подсчитываем количество документов в коллекции каждого из шардов через разные реплики
###

printf "\n\nshard1-1\n"
docker compose exec -T shard1-1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

printf "\n\nshard1-2\n"
docker compose exec -T shard1-2 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

printf "\n\nshard1-3\n"
docker compose exec -T shard1-3 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

printf "\n\nshard2-1\n"
docker compose exec -T shard2-1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

printf "\n\nshard2-2\n"
docker compose exec -T shard2-2 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

printf "\n\nshard2-3\n"
docker compose exec -T shard2-3 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
