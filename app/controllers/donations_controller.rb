class DonationsController < ApplicationController
 
  require 'time'
  skip_before_filter :authenticate_user!, :only => [:index]

  def index
  	@donations = Donation.where("donor_id is not null").order("name")
  end  

  def new
    @donation = Donation.new
  end

  def create
    status = Transaction::GuardedBlock.execute do |g|
      for row in (1..params[:max_row].to_i)
        key_value = ["name", "amount", "refered_by", "date_collected", "description"].inject({}){|acc,val| acc.merge!({val => params["donation"][val][row.to_s]}) }
        g.b { Donation.create_donation(key_value) }
      end  
    end
    if status
      flash[:notice] = "Donation was saved" 
      redirect_to donations_path
    else
      flash[:notice] = "Donation was not saved" 
      render :action => :new
    end 
  end

  def edit
  	@donation = Donation.find(params[:id])
  end

  def update
  	@donation = Donation.find(params[:id])
  	if @donation.update_attributes(params[:donation])
  	  flash[:notice] = "Donation was saved"	
  	  redirect_to donations_path
  	else
  	  flash[:notice] = "Donation was not saved"	
  	  render :action => :new
  	end
  end

  def destroy
  	@donation = Donation.find(params[:id])
  	@donation.destroy
  	redirect_to donations_path
  end

  def search
    from_date = Time.parse(params[:donation][:date_collected1])
    to_date = Time.parse(params[:donation][:date_collected2])
    from_date.strftime("%y-%m-%d")
    to_date.strftime("%y-%m-%d")
    con = []
    con << "name like '%#{params[:donation][:name]}%'" unless params[:donation][:name].blank?
    con << "amount = '#{params[:donation][:amount]}'" unless params[:donation][:amount].blank?
    con << "date(date_collected) between '#{from_date}' and '#{to_date}'" unless from_date.blank?
    @donations = Donation.where(con.join(" and ")).order("name")
    render :action => :index
  end

  def reports
    @donations = Donation.order("date_collected, id")
  end  

end
