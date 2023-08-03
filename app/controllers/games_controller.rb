require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('a'..'z').to_a
    @letters = []
    10.times do
      random_index = rand(1..26)
      @letters << alphabet[random_index - 1]
    end
    # display new random grid and form
  end

  def score
    @letters = params[:letters].chars
    letters_hash = frequency_hash(@letters)

    @word = params[:word]
    word_hash = frequency_hash(@word.chars)

    @is_subset = word_hash.all? do |letter, count|
      count <= letters_hash[letter]
    end

    # words are from grid but are not valid
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    @is_valid = user['found']
    # 3 words are from grid and valid

    @score = @word.length
    session[:score] ||= 0
    if @is_subset && @is_valid
      @grand_score = session[:score] += @score
    else
      @grand_score = session[:score] += 0
    end
    # figure out how to reset score based on redirecting of session/reset of score
  end

  def reset_score
    session[:score] = 0
    flash[:notice] = 'Score reset successfully.'

    redirect_to new_path
  end

  private

  def frequency_hash(array)
    freq_hash = Hash.new(0)
    array.each do |letter|
      freq_hash[letter] += 1
    end
    freq_hash
  end
end
