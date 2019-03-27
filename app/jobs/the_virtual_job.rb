# frozen_string_literal: true

# raises an exception if the first argument is false, or writes the second
# argument to a file
class TheVirtualJob < ApplicationJob
  queue_as :virtual

  def perform(*args)
    raise ZeroDivisionError, args[1] unless args[0]

    File.open(File.join(__dir__, '..', '..', 'tmp', 'out.log'), 'a') do |f|
      f.write(args[1])
    end
  end
end
