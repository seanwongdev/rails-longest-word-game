require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "typing in a random word in /new and not getting score recorded" do
    visit new_url
    fill_in "word", with: "hello"
    li_elements = all('ul li', count: 10)
    li_text_content = li_elements.map(&:text)
    click_on "Play"
    assert_text "Sorry but HELLO can't be built out of #{li_text_content.join(', ').upcase}"
  end
end
