const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const allRoutes = require("./routes/allRoutes");

dotenv.config();

// Declarations
const app = express();
const PORT_NUMBER = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json()); 

// API Endpoints
app.use("/api", allRoutes);

// Start Server
app.listen(PORT_NUMBER, () => {
    console.log(`Server is running on ${PORT_NUMBER}`);
});
