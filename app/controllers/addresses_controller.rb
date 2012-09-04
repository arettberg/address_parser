class AddressesController < ApplicationController
  
  include AddressesHelper

  def index
    @addresses = Address.all
    @address = Address.new
  end

  def create
    parse_hash = parse_address_text(params[:address][:text_block])
    
    @address = Address.new(parse_hash[:address])
    
    if @address.save
      redirect_to root_path
    else
        @addresses = Address.all
        render 'index'
    end
  end
  
  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    
    redirect_to root_path
  end
end
