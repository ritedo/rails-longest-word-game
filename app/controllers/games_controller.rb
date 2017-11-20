require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @end_time = Time.now
    @start_time = params[:start_time].to_datetime
    @time = @end_time - @start_time
    @word = params[:word].downcase
    @letters = params[:letters].downcase.split(",")
    if @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter)}
      response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
      json = JSON.parse(response.read)
      if json['found']
        @score = ((50 * @word.length) - (0.0001 * @time)).round(2)
        @result = "#{@score} Congratulation, #{@word} is a valid English word!"
      else
        @score = 0
        @result = "Sorry, but #{@word} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry, but #{@word} can't be built out of #{@letters}"
      @score = 0
    end
    session[:score].nil? ? session[:score] = @score : session[:score] += @score
  end
end
