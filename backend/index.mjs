import express from 'express'

const app = express()

app.route('/').get((req, res) => {
  console.log('Logger: 1')

  res.json({message: 'Ian'})
})

app.listen(4000)
