defmodule Tunez.Accounts.ArtistFollowerTest do
  use Tunez.DataCase, async: true

  alias Tunez.Music, warn: false

  describe "Tunez.Music.follow_artist/2" do
    # @tag skip: "can be enabled during chapter 9"
    test "creates a specific ArtistFollower record" do
      # Create some extra records so we can assert that only the correct link is created
      [artist_one, artist_two] = generate_many(artist(), 2)
      [_user_one, user_two] = generate_many(user(), 2)

      assert Music.follow_artist!(artist_one, actor: user_two)

      followers = Ash.load!(artist_one, :followers, authorize?: false).followers
      assert length(followers) == 1
      assert hd(followers).id == user_two.id

      assert [] == Ash.load!(artist_two, :followers, authorize?: false).followers
    end
  end

  describe "Tunez.Music.unfollow_artist/2" do
    # @tag skip: "can be enabled during chapter 9"
    test "deletes a specific ArtistFollower record" do
      # Create some extra records so we can assert that only the correct link is deleted
      [artist_one, artist_two] = generate_many(artist(), 2)
      [user_one, user_two] = generate_many(user(), 2)

      Music.follow_artist!(artist_one, actor: user_one)
      Music.follow_artist!(artist_one, actor: user_two)

      Music.follow_artist!(artist_two, actor: user_one)
      Music.follow_artist!(artist_two, actor: user_two)

      assert Music.unfollow_artist!(artist_two, actor: user_one)

      followers = Ash.load!(artist_two, :followers, authorize?: false).followers
      assert length(followers) == 1
      assert hd(followers).id == user_two.id

      followers = Ash.load!(artist_one, :followers, authorize?: false).followers
      assert length(followers) == 2
    end
  end

  describe "tunez.accounts.user relationships" do
    test "loads the artists followed by a user" do
      [artist_one, _artist_two] = generate_many(artist(), 2)
      [user_one, user_two] = generate_many(user(), 2)

      Music.follow_artist!(artist_one, actor: user_two)

      followed_artists =
        Ash.load!(user_two, :followed_artists, authorize?: false).followed_artists

      assert length(followed_artists) == 1
      assert hd(followed_artists).id == artist_one.id

      assert [] ==
               Ash.load!(user_one, :followed_artists, authorize?: false).followed_artists
    end

    test "loads all followed artists for a user" do
      [artist_one, artist_two, artist_three] = generate_many(artist(), 3)
      [user_one, user_two] = generate_many(user(), 2)

      Music.follow_artist!(artist_one, actor: user_one)
      Music.follow_artist!(artist_two, actor: user_one)

      Music.follow_artist!(artist_three, actor: user_two)

      followed_artists =
        Ash.load!(user_one, :followed_artists, authorize?: false).followed_artists

      assert Enum.map(followed_artists, & &1.id) |> Enum.sort() ==
               Enum.sort([artist_one.id, artist_two.id])

      followed_artists =
        Ash.load!(user_two, :followed_artists, authorize?: false).followed_artists

      assert Enum.map(followed_artists, & &1.id) == [artist_three.id]
    end
  end

  describe "policies" do
    def setup_users do
      %{
        admin: generate(user(role: :admin)),
        editor: generate(user(role: :editor)),
        user: generate(user(role: :user))
      }
    end

    # @tag skip: "can be enabled during chapter 9. Also uncomment the `setup_users` function above"
    test "all authenticated users can follow artists" do
      users = setup_users()
      artist = generate(artist())

      assert Music.can_follow_artist?(users.admin, artist)
      assert Music.can_follow_artist?(users.editor, artist)
      assert Music.can_follow_artist?(users.user, artist)
      refute Music.can_follow_artist?(nil, artist)
    end

    # @tag skip: "can be enabled during chapter 9. Also uncomment the `setup_users` function above"
    test "all authenticated users can unfollow artists" do
      users = setup_users()
      artist = generate(artist())

      assert Music.can_unfollow_artist?(users.admin, artist)
      assert Music.can_unfollow_artist?(users.editor, artist)
      assert Music.can_unfollow_artist?(users.user, artist)
      refute Music.can_unfollow_artist?(nil, artist)
    end
  end
end
