class MusicLibraryController
  attr_accessor :path

  def initialize(path = './db/mp3s')
    @path =  path
    MusicImporter.new(path).import
  end

  def call
    puts "Welcome to your music library!"
    puts "To list all of your songs, enter 'list songs'."
    puts "To list all of the artists in your library, enter 'list artists'."
    puts "To list all of the genres in your library, enter 'list genres'."
    puts "To list all of the songs by a particular artist, enter 'list artist'."
    puts "To list all of the songs of a particular genre, enter 'list genre'."
    puts "To play a song, enter 'play song'."
    puts "To quit, type 'exit'."
    puts "What would you like to do?"

    input = gets.chomp

    until input == "exit"
      case input
      when "list songs"
        list_songs
      when "list artists"
        list_artists
      when "list genres"
        list_genres
      when "list artist"
        list_songs_by_artist
      when "list genre"
        list_songs_by_genre
      when "play song"
        play_song
      end

      input = gets.chomp
    end
  end

  def sort_by_name(objects)
    objects.sort_by {|object| object.name}
  end

  def list_songs
    sorted_songs = sort_by_name(Song.all)

    sorted_songs.each_with_index do |song, index|
      puts "#{index + 1}. #{song.artist.name} - #{song.name} - #{song.genre.name}"
    end
  end

  def list_artists
    sorted_artists = sort_by_name(Artist.all)

    sorted_artists.each_with_index do |artist, index|
      puts "#{index + 1}. #{artist.name}"
    end
  end

  def list_genres
    sorted_genres = sort_by_name(Genre.all)

    sorted_genres.each_with_index do |genre, index|
      puts "#{index + 1}. #{genre.name}"
    end
  end

  def list_songs_by_artist
    puts "Please enter the name of an artist:"

    artist_name = gets.chomp

    artist = Artist.find_by_name(artist_name)

    if artist == nil
      return
    end

    sorted_songs = sort_by_name(artist.songs)

    sorted_songs.each_with_index do |song, index|
      puts "#{index + 1}. #{song.name} - #{song.genre.name}"
    end
  end

  def list_songs_by_genre
    puts "Please enter the name of a genre:"

    genre_name = gets.chomp

    genre = Genre.find_by_name(genre_name)

    if genre == nil
      return
    end

    sorted_songs = sort_by_name(genre.songs)

    sorted_songs.each_with_index do |song, index|
      puts "#{index + 1}. #{song.artist.name} - #{song.name}"
    end
  end

  def play_song
    puts "Which song number would you like to play?"

    song_number = gets.chomp.to_i

    sorted_songs = sort_by_name(Song.all)

    if song_number <= 0 || song_number > sorted_songs.length
      return
    end

    chosen_song = sorted_songs[song_number - 1]

    puts "Playing #{chosen_song.name} by #{chosen_song.artist.name}"

    # filename = "#{chosen_song.artist.name} - #{chosen_song.name} - #{chosen_song.genre.name}.mp3"
    # system("open \"./db/mp3s/#{filename}\"")
  end
end