class Url < ActiveRecord::Base
  validates :address, presence: true

  has_many   :payload_requests
  has_many   :request_types, through: :payload_requests
  has_many   :referrals, through: :payload_requests
  has_many   :software_agents, through: :payload_requests

  def all_response_times
    payload_requests.pluck(:responded_in).sort.reverse.sort
  end

  def average_response_time
    payload_requests.average(:responded_in).to_i
  end

  def all_verbs
    request_types.pluck(:verb)
  end

  def most_popular_referrers
    freq = referrals.group(:address).count
    data_set = freq.sort_by {|url,num| num}.sort_by(&:last).reverse
    top_three = data_set[0..2].map { |url, num| url }.sort.join(', ')
  end

  def most_popular_user_agents
    freq = software_agents.group(:message).count.map do |key, value|
      [UserAgent.parse(key).browser, UserAgent.parse(key).os, value]
    end
    # ranked_ua = freq.sort_by {|ua| ua[-1]}[-3..-1].reverse
      ranked_ua = freq.sort_by{|b,o,num| num}.sort_by(&:last).reverse
    # ranked_ua.map { |ua| ua[0..1] }
      ranked_ua[0..2].map { |b,o,num| [b,o] }.uniq.map {|x| x.join(" + ")}.sort.join(', ')
  end

  def self.relative_path(address)
    address.split('/')[3]
  end

  def max_response_time
    payload_requests.maximum(:responded_in)
  end

  def min_response_time
    payload_requests.minimum(:responded_in)
  end

  def all_response_times
    payload_requests.pluck(:responded_in).sort.join(', ')
  end

  def average_response_time
    payload_requests.average(:responded_in).to_i
  end

  def all_verbs
    request_types.pluck(:verb).uniq.sort.join(', ')
  end

end
