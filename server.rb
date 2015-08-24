require "sinatra"
require 'pry'

use Rack::Session::Cookie, {
  secret: "keep_it",
  expire_after: 10 # seconds
}

def play(player_choice)

  computer_choice = rand(3)
  case computer_choice
    when 0
      computer_choice = "rock"
    when 1
      computer_choice = "paper"
    else
      computer_choice = "scissors"
  end

  statement = "You chose #{player_choice}, computer chose #{computer_choice}. "

  if player_choice == computer_choice
    statement << "Tie, no winner."
  elsif player_choice == "rock" && computer_choice == "paper"
    statement << "Computer wins the round."
  elsif player_choice == "rock" && computer_choice == "scissors"
    statement << "Human wins the round."
  elsif player_choice == "paper" && computer_choice == "rock"
    statement << "Human wins the round."
  elsif player_choice == "paper" && computer_choice == "scissors"
    statement << "Computer wins the round."
  elsif player_choice == "scissors" && computer_choice == "rock"
    statement << "Computer wins the round."
  else
    statement << "Human wins the round."
  end
  statement
end

get "/choose" do
  if session[:human_choice].nil?
    statement = ""
    session[:human_score] = 0
    session[:computer_score] = 0
  end
  erb :index, locals: { statement: session[:statement], human_score: session[:human_score], computer_score: session[:computer_score], winner: session[:winner]}
end

post "/choose" do
  human_choice = params[:choice]
  session[:human_choice] = human_choice
  statement = play(human_choice)
  winner = nil

  if session[:human_choice] == "Play again" #|| session[:human_choice].nil?
    session[:human_score] = 0
    session[:computer_score] = 0
    statement = ""
  elsif statement.include?("Human wins")
    session[:human_score] += 1
    winner = "You win!" if session[:human_score] == 2
  elsif statement.include?("Computer wins")
    session[:computer_score] += 1
    winner = "You suck at buttons!" if session[:computer_score] == 2
  end

  session[:winner] = winner
  session[:statement] = statement
  redirect "/choose"
end
