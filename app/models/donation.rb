class Donation < ActiveRecord::Base
  # validates :name,:donor_id,:amount, :presence => true

  def Donation.create_donation(params)
    last = Donation.where("donor_id is not null").last
    last_donor_id = last.donor_id.to_s.split("DNR") if !last.nil?
    new_id = last.nil? ? "DNR1" : "DNR" + (last_donor_id[1].to_i + 1).to_s
    donation = Donation.new(params.merge(:donor_id => new_id))
    donation.save
  end

end