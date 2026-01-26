const formatLyrics = (rawLyrics) => {
  if (!rawLyrics) return null;

  const startIndex = rawLyrics.search(/\[(Intro|Verse|Chorus|Bridge|Outro)/i);
  if (startIndex === -1) return rawLyrics.trim();

  return rawLyrics
    .slice(startIndex)
    .replace(/\n{3,}/g, "\n\n")
    .trim();
};

module.exports = {
    formatLyrics
}
