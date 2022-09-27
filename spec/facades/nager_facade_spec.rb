# require 'rails_helper'

# RSpec.describe NagerFacade do
#   it 'formats the service response' do

#  parsed = [
#   {
#     "date": "2022-10-10",
#     "localName": "Columbus Day",
#     "name": "Columbus Day",
#     "countryCode": "US",
#     "fixed": false,
#     "global": false,
#     "counties": [
#       "US-AL",
#       "US-AZ",
#       "US-CO",
#       "US-CT",
#       "US-DC",
#       "US-GA",
#       "US-ID",
#       "US-IL",
#       "US-IN",
#       "US-IA",
#       "US-KS",
#       "US-KY",
#       "US-LA",
#       "US-ME",
#       "US-MD",
#       "US-MA",
#       "US-MS",
#       "US-MO",
#       "US-MT",
#       "US-NE",
#       "US-NH",
#       "US-NJ",
#       "US-NM",
#       "US-NY",
#       "US-NC",
#       "US-OH",
#       "US-OK",
#       "US-PA",
#       "US-RI",
#       "US-SC",
#       "US-TN",
#       "US-UT",
#       "US-VA",
#       "US-WV"
#     ],
#     "launchYear": null,
#     "types": [
#       "Public"
#     ]
#   },
#   {
#     "date": "2022-11-11",
#     "localName": "Veterans Day",
#     "name": "Veterans Day",
#     "countryCode": "US",
#     "fixed": false,
#     "global": true,
#     "counties": null,
#     "launchYear": null,
#     "types": [
#       "Public"
#     ]
#   },
#   {
#     "date": "2022-11-24",
#     "localName": "Thanksgiving Day",
#     "name": "Thanksgiving Day",
#     "countryCode": "US",
#     "fixed": false,
#     "global": true,
#     "counties": null,
#     "launchYear": 1863,
#     "types": [
#       "Public"
#     ]
#   }]

#     upcoming_holidays_arr = ["Columbus Day", "Veterans Day", "Thanksgiving Day"]
#     service_response = double('service_response')
#     response_body = double('response body')

#     allow(NagerService).to receive(:holidays).and_return(service_response)
#     allow(service_response).to receive(:body).and_return(response_body)
#     allow(JSON).to receive(:parse).and_return(parsed)
#     # expect(NagerFacade.upcoming_holidays).to eq(upcoming_holidays_arr)
#   end
# end