# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  movie_title_cells = page.all('#movies tbody tr td:first-child')
  movie_title_cells.each_with_index do |movie_title_cell, index|
    expect(movie_title_cells[index + 1].text).to eq e2 if e1 == movie_title_cell.text
    #puts movie_title_cells[index + 1].text 
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    uncheck('ratings_' + rating.strip)
  end
end

And /I press the "(.*)" button/ do |button|
  click_button(button)
end

Then /I should only see "(.*)", "(.*)", "(.*)", "(.*)", "(.*)" in the movie list/ do |*movies|
  movies_listed = page.all('#movies tbody tr td:first-child').map do |row|
    row.text
  end
  expect(movies_listed).to match_array movies
end

When /all ratings are checked/ do
  page.all('#ratings_form input[type=checkbox]').each do |checkbox|
    checkbox.set(true)
  end
end

Then /I should see all the movies/ do
  expect(page.all('#movies tbody tr').size).to equal 10
end