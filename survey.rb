require 'active_record'
require './lib/survey'
require './lib/question'
require './lib/answer'
require './lib/response'

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

def user_menu
  puts "Welcome Earthling."
  puts "To View a List of Surveys to Take, press 'S'"
  user_input = gets.chomp.downcase
  case user_input
  when 's' then view_surveys
  else
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
  survey = Survey.new(:name => new_survey)
  if survey.save
    puts "You created '#{new_survey}'"
    puts "Here is a list of all of the Surveys:"
    Survey.all.each { |name| puts name.name }
    puts "We are returning to the designer menu"
    designer_menu
  else
    puts "That wasn't a valid Survey Name"
    survey.errors.full_messages.each { |message| puts message }
  end
end

def view_surveys
  puts "Here is a list of current surveys:"
  Survey.all.each_with_index { |name, index| puts "#{index+1}. #{name.name}"}
  puts "Would you like to view a list's questions?"
  puts "y for yes and n for no"
  input = gets.chomp
  case input
  when 'y'
    question_view
  else
  puts "We are returning to the designer menu and later we can view the answers to the selected survey"
  designer_menu
  end
end

def edit_surveys
  puts "Choose a Survey by Index from the List to Edit"
  survey_to_edit = Survey.all.each_with_index { |name, index| puts "#{index+1}. #{name.name}"}
  input = gets.chomp.to_i
  current_survey = survey_to_edit[input-1]
  puts "Now taking you to the question creator"
  new_question(current_survey)
end

def new_question(survey)
  puts "Add a Question:"
  new_question = gets.chomp
  new_question = Question.create(:question => new_question, :survey_id => survey.id)
  puts "Entering the answer creator"
  new_answer(new_question)
  puts "Would you like to add another question? 'Y' or 'N'"
  input = gets.chomp
  case input
  when 'y' then new_question(survey)
  when 'n' then designer_menu
  else puts "That is not a valid option"
  end
end

def new_answer(question)
  puts "Welcome to the answer creator"
  puts "Enter an answer for '#{question.question}'"
  answer = gets.chomp
  new_answer = Answer.create(:answers => answer, :question_id => question.id)
  puts "Would you like to add another answer? 'Y' or 'N'"
  input = gets.chomp.downcase
  case input
  when 'y'
    new_answer(question)
  when 'n'
  else puts "Please choose a valid option"
  end
end

def question_view
  puts 'Choose the index of the list to open'
  selected_survey = Survey.all.each_with_index { |name, index| puts "#{index+1}. #{name.name}"}
  input = gets.chomp.to_i
  to_open = selected_survey[input-1]
  to_open.questions.each_with_index { |question, index| puts "#{index+1}. #{question.question}"}
  puts "Would you like to answer a question? 'Y' or 'N'"
  input = gets.chomp.downcase
  case input
  when 'y'
    answer_view(to_open)
  when 'n'
    main_menu
  else
    puts "that is not a valid option"
    question_view
  end
end

def answer_view(to_open)
  puts 'Choose the index of the question to open'
  selected_question = to_open.questions.each_with_index { |question, index| puts "#{index+1}. #{question.question}"}
  input = gets.chomp.to_i
  to_open = selected_question[input-1]
  selected_answer = to_open.answers.each_with_index { |answer, index| puts "#{index+1}. #{answer.answers}"}
  puts "Choose an answer:"
  user_answer = gets.chomp
  to_open = selected_answer[input-1]
  response = Response.create(:name => selected_answer.answers, :answer_id => to_open)
  puts response

end

def delete_surveys
  puts "Here is a list of your Surveys, choose the index of the Survey that you would like to Delete:"
  Survey.all.each_with_index { |name, index| puts "#{index+1}. #{name.name}"}
  to_delete = gets.chomp.to_i
  result = Survey.all.find(to_delete)
  result.destroy
  puts "Your Collection of Surveys is now as follows:"
  Survey.all.each_with_index { |name, index| puts "#{index+1}. #{name.name}"}
end

def answers
end



def user_menu

end



title_menu
