#!/bin/bash

###
# Инициализируем сервер конфигурации
###

docker compose exec -T configSrv-1 mongosh --port 27019 --quiet <<EOF
rs.initiate({
  _id: "config_server",
  configsvr: true,
  members: [
    {_id: 0, host: "configSrv-1:27019"},
    {_id: 1, host: "configSrv-2:27019"},
    {_id: 2, host: "configSrv-3:27019"},
  ],
})

while (!rs.status().members.some(member => member.stateStr === "PRIMARY")) {
  console.log("Waiting for config server to be ready...")
  sleep(1000)
}
EOF

###
# Инициализируем шарды
###

printf "\n\n"
docker compose exec -T shard1-1 mongosh --port 27018 --quiet <<EOF
rs.initiate({
  _id : "shard1",
  members: [
    {_id: 0, host: "shard1-1:27018"},
    {_id: 1, host: "shard1-2:27018"},
    {_id: 2, host: "shard1-3:27018"},
  ],
})

while (!rs.status().members.some(member => member.stateStr === "PRIMARY")) {
  console.log("Waiting for shard1 to be ready...")
  sleep(1000)
}
EOF

printf "\n\n"
docker compose exec -T shard2-1 mongosh --port 27018 --quiet <<EOF
rs.initiate({
  _id : "shard2",
  members: [
    {_id: 0, host: "shard2-1:27018"},
    {_id: 1, host: "shard2-2:27018"},
    {_id: 2, host: "shard2-3:27018"},
  ],
})

while (!rs.status().members.some(member => member.stateStr === "PRIMARY")) {
  console.log("Waiting for shard2 to be ready...")
  sleep(1000)
}
EOF

###
# Инициализируем роутеры и наполняем данными
###

printf "\n\n"
docker compose exec -T mongos-1 mongosh --port 27017 --quiet <<EOF
sh.addShard("shard1/shard1-1:27018")
sh.addShard("shard2/shard2-1:27018")

sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", {"name": "hashed"})

use somedb
for (let i = 0; i < 1000; i++) db.helloDoc.insertOne({age: i, name: "ly" + i})
EOF

printf "\n\n"
docker compose exec -T mongos-2 mongosh --port 27017 --quiet <<EOF
sh.addShard("shard1/shard1-1:27018")
sh.addShard("shard2/shard2-1:27018")
EOF
