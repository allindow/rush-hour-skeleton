require_relative 'payload_request'

class RequestType < ActiveRecord::Base
  validates :verb, presence: true
  has_many :payload_requests

  def most_frequent_request
    all_requests = PayloadRequest.all
  end
end
