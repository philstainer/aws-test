import express from 'express'

const app = express()

app.route('/').get((req, res) => res.json({ message: 'OK' }))

app.listen(3000)