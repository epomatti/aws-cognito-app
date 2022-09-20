import * as dotenv from 'dotenv';
dotenv.config();
import express from 'express';

const app = express();
app.use(express.json());

export const start = async () => {

  app.get('/api/data', (req, res) => {
    res.sendStatus(200);
  })

  const port = 5000;
  app.listen(port, () => {
    console.log(`Worker endpoint started on port ${port}`)
  })
}