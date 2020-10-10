import express from 'express'

const app = express()

app.route('/').get((req, res) => res.json({message: 'Ian'}))

app.listen(4000)
