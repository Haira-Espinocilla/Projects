import express from 'express';
import router from './routes/router.js';
import dotenv from 'dotenv';
import initDB from './config/db.js';
import cors from 'cors';
import bodyParser from 'body-parser';

dotenv.config();    // load env
initDB();           // connect to database

const app = express();
const PORT = process.env.PORT;

// moved cors before other middleware to ensure headers are set
app.use(cors({
    origin: 'http://localhost:5173', // vite frontend
    methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE'], // needed methods
    credentials: true, // for sending of tokens
})); 

app.use(express.json()); // changed from body parser
app.use(express.urlencoded({ extended: false }));



// Routes
router(app);

// Start server
app.listen(PORT, () => {
    console.log(`Server running at PORT: ${PORT}`)
});


