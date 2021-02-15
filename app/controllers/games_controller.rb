require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @letters = params[:letters].split('')
    @word = params[:word].upcase

    @result = if not_in_grid?(@word, @letters)
                "Some letter of #{@word} is not in the grid."
              elsif no_word?(@word)
                "Sorry. But #{@word} is not a valid English word."
              else
                "Congratulations! #{@word} is a valid English word!"
              end
  end
end


private

def no_word?(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  serialized = URI.open(url).read
  !JSON.parse(serialized)['found']
end

def not_in_grid?(attempt, grid)
  attempt.chars.each do |letter|
    return false if attempt.scan(letter).count <= grid.join.scan(letter).count
  end
end
