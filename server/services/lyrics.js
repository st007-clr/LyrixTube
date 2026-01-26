const play = require("play-dl");
const Genius = require("genius-lyrics");
const { formatLyrics } = require("../utils/formatLyrics");

const Client = new Genius.Client(process.env.GENIUS_TOKEN);

const getGenerateLyrics = async (link) => {
  // Validate YouTube URL
  if (!play.yt_validate(link)) {
    throw new Error("Invalid YouTube URL");
  }

  // Fetch YouTube video info
  const info = await play.video_basic_info(link);
  const videoDetails = info.video_details;
  const rawTitle = videoDetails.title;
  const channelName = videoDetails.channel?.name || "";

  // Clean title
  const cleanedTitle = rawTitle
    .replace(/\(.*?\)|\[.*?\]/g, "")
    .replace(
      /official music video|official video|official audio|lyric video|lyrics?/gi,
      "",
    )
    .trim();

  let artist = "";
  let song = "";

  if (cleanedTitle.includes("-")) {
    [artist, song] = cleanedTitle.split("-").map((t) => t.trim());
  } else {
    artist = channelName;
    song = cleanedTitle;
  }

  if (!artist || !song) {
    throw new Error("Unable to detect artist or song name");
  }

  // Search on Genius
  const searches = await Client.songs.search(`${artist} ${song}`);

  if (!searches.length) {
    throw new Error("Song not found on Genius");
  }

  // Pick best match (first result)
  const geniusSong = searches[0];

  // Fetch lyrics (scraped)
  const rawLyrics = await geniusSong.lyrics();
  const lyrics = formatLyrics(rawLyrics);

  if (!lyrics) {
    throw new Error("Lyrics not available");
  }

  return {
    artist,
    song,
    lyrics,
  };
};

module.exports = { getGenerateLyrics };
