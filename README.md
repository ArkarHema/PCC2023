# GeKovaiInnovators - GE PCC 2023

Welcome to the GeKovaiInnovators project for GE PCC 2023!

## Installation

To set up this project, follow these steps:

### Server

1. Create a `.env` file in the server directory if it doesn't already exist.

2. Inside the `.env` file, set the following environment variables:

   ```plaintext
   MONGODB_URI = "your_mongodb_url"
   JWT_SECRET = "your_jwt_secret"
   PORT = 3000 (or your choice)
   ```

   - `MONGODB_URI`: Replace `"your_mongodb_url"` with the actual URL of your MongoDB database. for atlas mongodb+srv://nakulbr:nakulbr@cluster0.vwuj1vj.mongodb.net/GeHealthcare
   - `JWT_SECRET`: Replace `"your_jwt_secret"` with a strong, secret key for JSON Web Token (JWT) authentication.
   - `PORT`: You can set the server's port to `3000` or any other port of your choice.

### Prescription Software

1. Create a `.env` file in the prescription directory if it doesn't already exist.

2. Inside the `.env` file, set the following environment variable:

   ```plaintext
   SERVER_URL = "your_server_url"
   ```

   - `SERVER_URL`: Replace `"your_server_url"` with the actual URL of your server. for now "http://localhost:3000"

### Patient app

1. Create `lib/.env`
2. Add `OPENAPITOKEN`
3. Add `SERVER_URL`

### TO run server

1. cd to server/
2. npm i
3. npm run dev
