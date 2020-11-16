require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letter_range = ("a".."z").to_a
    @letters = []
    10.times do 
      @letters << letter_range.sample.upcase
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    grid = @letters.split(",")
    test1 = test_letter_grid(@word, grid)
    test2 = test_english(@word)
    @message = message(test1, test2, @word, @letters)
  end

  private

  def test_letter_grid(attempt, grid)
    attempt.upcase.chars.each do |letter|
      index = grid.index(letter)
      return false unless index
  
      grid.delete_at(index)
    end
    true
  end

  def test_english(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    ficher = open(url).read
    hash = JSON.parse(ficher)
    return hash["found"]
  end

  def message(test1, test2, word, letters)
    if test1 && test2
      message = " Well done! #{word} is a valid English word"
    elsif test2 == false
      message = "Sorry, #{word} is not an english word..."
    else
      message = "Sorry but #{word} can't be built out of  #{letters}"
    end
    return message
  end  
end
