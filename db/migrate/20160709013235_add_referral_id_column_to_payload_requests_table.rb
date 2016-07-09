class AddReferralIdColumnToPayloadRequestsTable < ActiveRecord::Migration
  def change
    add_column :payload_requests, :referral_id, :integer
  end
end
