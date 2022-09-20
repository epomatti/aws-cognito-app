import * as dotenv from 'dotenv';
dotenv.config();
import express from 'express';
import cors from 'cors';

const app = express();
app.use(express.json());
app.use(cors())

export const start = async () => {

  app.get('/api/data', (req, res) => {
    const data = {
      bankBalance: 50,
      aaa: 3
    }
    res.status(200).send(data);
  })

  const port = 5000;
  app.listen(port, () => {
    console.log(`Worker endpoint started on port ${port}`)
  })
}