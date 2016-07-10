class PayloadRequest < ActiveRecord::Base
  validates :url_id, presence: true
  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :request_type_id, presence: true
  validates :resolution_id, presence: true
  validates :ip_id, presence: true
  validates :software_agent_id, presence: true
  validates :client_id, presence: true
  validates :referral_id, presence: true
  validates_uniqueness_of :client_id, :scope => [:url_id, :requested_at, :responded_in, :request_type_id, :resolution_id, :ip_id, :software_agent_id]

  belongs_to :resolution
  belongs_to :url
  belongs_to :request_type
  belongs_to :software_agent
  belongs_to :ip
  belongs_to :client
  belongs_to :referral

  def self.most_frequent_request_type
    verbs = PayloadRequest.pluck(:request_type_id)
    freq = verbs.reduce(Hash.new(0)) { |hash,value| hash[value] += 1; hash }
    id = freq.max_by { |key,value| value}
    id = id.first
    RequestType.find(id).verb
  end

  def self.url_frequency
    addresses = PayloadRequest.pluck(:url_id)
    freq = addresses.reduce(Hash.new(0)) { |hash,value| hash[value] += 1; hash }
    url = freq.sort_by { |key,value| value}.reverse
    url.map do |item|
      Url.find(item[0]).address
    end
  end

  def self.max_response_time
    PayloadRequest.maximum(:responded_in)
  end
  
end
