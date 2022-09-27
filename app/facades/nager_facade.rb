require 'nager_service'
require 'json'

  class NagerFacade
    def self.upcoming_holidays
      response = NagerService.holidays
      parsed = JSON.parse(response.body)
      holiday_names = []
      parsed.each do |holiday|
         holiday_names << holiday["name"]
      end
      holiday_names[0..2].each do |holiday_name|
          holiday_name
      end
    end
  end