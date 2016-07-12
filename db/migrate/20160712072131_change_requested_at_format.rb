class ChangeRequestedAtFormat < ActiveRecord::Migration
  def change
    change_column :payload_requests, :requested_at, :text
  end
end
