const express = require("express");
const router = express.Router();
const { generateLyrics } = require("../controllers/lyrics");

router.post("/generate-lyrics", generateLyrics)

module.exports = router;