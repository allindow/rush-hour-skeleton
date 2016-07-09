class RemoveReferralIdFromUrlsTable < ActiveRecord::Migration
  def change
    remove_column :urls, :referral_id
  end
end
