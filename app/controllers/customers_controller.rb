# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show update destroy]

  def index
    @customers = Customer.all
  end

  def show; end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      render :show, status: :created, location: @customer
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params)
      render :show, status: :ok, location: @customer
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name)
  end
end
