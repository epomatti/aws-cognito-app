import * as dotenv from 'dotenv';
dotenv.config();
import express from 'express';
import cors from 'cors';
import * as oidc from 'express-openid-connect';

const app = express();
app.use(express.json());
app.use(cors())
app.use(
  oidc.auth({
    issuerBaseURL: process.env.ISSUER_BASE_URL,
    baseURL: process.env.BASE_URL,
    clientID: process.env.CLIENT_ID,
    secret: process.env.SECRET,
    idpLogout: true,
  })
);

export const start = async () => {

  app.get('/api/data', (req, res) => {
    const data = {
      bankBalance: 50,
      aaa: 3
    }
    res.status(200).send(data);
  })

  app.get('/profile', (req: Express.Request, res: Express.Response) => {
    const user = req.oidc.user;
    console.log(user);
  })

  const port = 5000;
  app.listen(port, () => {
    console.log(`Worker endpoint started on port ${port}`)
  })
}


const { auth } = require('express-openid-connect');
