const express = require('express')
const app = express()
const port = 4399

app.post('/', (req, res) => {
  console.log(`Got request from client: ${req.headers['content-length']} bytes`)
  res.header('content-type', 'application/json')
  res.send('{ "response": "looks great!" }')
})

app.listen(port, () => {
  console.log(`Fake backend listening on ${port}`)
})