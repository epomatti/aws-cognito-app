import * as dotenv from 'dotenv';
dotenv.config();
import express from 'express';
import cors from 'cors';
import { auth, requiresAuth, ConfigParams } from 'express-openid-connect';

const app = express();
app.use(express.json());
app.use(cors())

const config: ConfigParams = {
  authRequired: true,
  baseURL: process.env.BASE_URL,
  clientID: process.env.CLIENT_ID,
  issuerBaseURL: process.env.ISSUER_BASE_URL,
  clientSecret: process.env.SECRET,
  authorizationParams: {
    response_type: "code"
  }
};

app.use(auth(config));

export const start = async () => {

  app.get('/', (req, res) => {
    res.send(req.oidc.isAuthenticated() ? 'Logged in' : 'Logged out')
  });

  app.get('/profile', requiresAuth(), (req, res) => {
    res.send(JSON.stringify(req.oidc.user));
  });

  const port = 5000;
  app.listen(port, () => {
    console.log(`Server started on port ${port}`)
  })
}
