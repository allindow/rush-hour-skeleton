class Resolution < ActiveRecord::Base
  validates :width,  presence: true
  validates :height, presence: true
  validates_uniqueness_of :width, :scope => :height
  has_many :payload_requests

  def self.all_resolutions_used
     widths = Resolution.pluck(:width)
     heights = Resolution.pluck(:height)
     widths.zip(heights).map do |resolution|
       "(#{resolution[0]} x #{resolution[1]})"
     end
   end
end
