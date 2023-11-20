# frozen_string_literal: true

class CreateTimeEntriesTask
  def self.create!
    sows = StatementOfWork.all

    sows.each do |sow|
      TeamMakerProjectCreator.new(sow).call
    end
  end
end
