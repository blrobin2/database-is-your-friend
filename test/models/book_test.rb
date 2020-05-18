require 'test_helper'

class BookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Reactive Test
  test "all books are valid" do
    errors = []
    Book.find_each do |book|
      next if book.valid?

      errors << [book.id, book.errors.full_messages]
    end
    assert_equal [], errors
  end
end
