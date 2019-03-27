# frozen_string_literal: true
require 'pp'

SUCCESS_DELAY = 1.second
FAILURE_DELAY = 1.minute

# Run the next job in the virtual queue
class RunVirtualJob < ApplicationJob
  queue_as :default

  def perform(*)
    next_delay = SUCCESS_DELAY
    job = Delayed::Job.ready_to_run('', Delayed::Worker.max_run_time).for_queues(:virtual).first

    next_delay = FAILURE_DELAY unless !job || Delayed::Worker.new.run(job)
  rescue StandardError
    next_delay = FAILURE_DELAY
  ensure
    RunVirtualJob.set(wait: next_delay).perform_later
  end
end
