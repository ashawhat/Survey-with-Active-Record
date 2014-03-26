require 'active_record'
require './lib/survey'
require './lib/question'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)


def title_menu
puts "Welcome to the Survey App"
main_menu
end

def main_menu
puts "Are you a Survey Designer?  Press 'D'"
puts "Are you a Survery Taker?  Press 'T'"
puts "Press 'X' to exit"
input = gets.chomp.downcase
case input
  when 'd' then designer_menu
  when 't' then user_menu
  when 'x' then puts "Goodbye!"
  else
    puts 'Not a Valid Key'
    main_menu
  end
end

def designer_menu
  puts "Press 'C' to create a new survey"
  puts "Press 'V' to view current surveys"
  puts "press 'E' to edit a survey"
  puts "Press 'D' to delete a survey"
  puts "Press 'A' to view responses"
  puts "Press 'B' to go back"

  input = gets.chomp.downcase
  case input
  when 'c' then create_survey
  when 'v' then view_surveys
  when 'e' then edit_surveys
  when 'd' then delete_surveys
  when 'a' then answers
  when 'b' then main_menu
  else
    puts "That is not a valid option"
    designer_menu
  end
end

def create_survey
  puts "Enter the Name of the New Survey:"
  new_survey = gets.chomp.titlecase
  Survey.create(:name => new_survey)
  puts "You created '#{new_survey}'"
  puts "Here is a list of all of the Surveys:"
  Survey.all.each { |name| puts name.name }
  puts "We are returning to the designer menu"
  designer_menu
end

def view_surveys
  puts "Here is a list of current surveys:"
  Survey.all.each_with_index { |name, index| puts "#{index+1}. #{name.name}"}
  puts "We are returning to the designer menu and later we can view the answers to the selected survey"
  designer_menu
end

def edit_surveys
  puts "Choose a Survey by Index from the List to Edit"
  Survey.all.each_with_index { |name, index| puts "#{index+1}. #{name.name}"}
  survey_to_edit = gets.chomp.to_i
  current_survey = Survey.all.find(survey_to_edit)
  puts "Now taking you to the question creator"
  new_question(current_survey)
end

def new_question(current_survey)
  puts "Add a Question:"
  new_question = gets.chomp
  new_question = Question.create(:question => new_question)
  puts "Now taking you to the answer creator"
  answers = []
  new_answer(new_question, answers)
end

def new_answer(new_question, answers)
  puts "Welcome to the answer creator"
  new_answer = gets.chomp
  answers << new_answer
  puts "Would you like to add another answer? 'Y' or 'N'"
  input = gets.chomp.downcase
  case input
  when 'y'
    new_answer(new_question, answers)
  when 'n'
    puts answers.flatten.split(" ")
  end
end

def delete_surveys
end

def answers
end



def user_menu

end



title_menu
