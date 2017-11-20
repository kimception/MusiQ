use Mix.Config

config :spotify_ex,
  user_id: "1245876682",
  callback_url: "http://musiq.sorryiateallyourpancakes.com:4000/authenticate",
  scopes: ["playlist-read-private", "playlist-modify-private", "playlist-modify-public","user-top-read", "user-read-playback-state", "user-modify-playback-state"]
