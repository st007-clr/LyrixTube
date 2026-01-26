const { getGenerateLyrics } = require("../services/lyrics");

const generateLyrics = async (req, res) => {
  try {
    const { link } = req.body;

    if (!link) {
      return res.status(400).json({
        status: "error",
        message: "YouTube link is required",
      });
    }

    const lyrics = await getGenerateLyrics(link);
    res.status(200).json({
      status: "success",
      data: lyrics,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
};

module.exports = {
  generateLyrics,
};
