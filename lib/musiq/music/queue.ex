require IEx
defmodule Musiq.Music.Queue do
  alias Musiq.Repo
  import Ecto.Query, only: [from: 2]

  def get(groupID) do
    group = Musiq.Music.get_group!(groupID)
    |> Repo.preload songs: from(s in Musiq.Music.Song, order_by: s.song_order)
    group.songs

  end

  def update(groupID, songs) do
    if List.first(songs["cards"])["artist"] == "ZZ TOP" do
      IEx.pry

    end
    group = Musiq.Music.get_group!(groupID)
    |> Repo.preload [:songs]
    query = from s in Musiq.Music.Song,
            where: s.group_id == ^groupID
    Repo.delete_all(query)
    change = Ecto.Changeset.change group, current_ms: 0
    Repo.update! change
    songs["cards"]
    |> Enum.with_index
    |> Enum.each(fn({song, index}) ->
      object = %{song_order: index, spotify_id: song["id"],
      title: song["title"], artist: song["artist"], group_id: groupID}
      Musiq.Music.create_song(object)
    end)
  end

  def update_state(groupID, state) do
    group = Musiq.Music.get_group!(groupID)
    change = Ecto.Changeset.change group, state: state
    Repo.update! change
  end


end
