# frozen_string_literal: true

class StandupsController < ApplicationController
  before_action :set_standup, only: [:edit, :update, :destroy]

  def index
    redirect_to(root_path)
  end

  def new
    @standup = Standup.new
  end

  def edit
    @standup = Standup.find(params[:id])
  end

  def create
    @standup = Standup.new(standup_params)
    @standup.user = current_user

    if @standup.save
      redirect_back(
        fallback_location: root_path,
        notice: "Standup was successfully created."
      )
    else
      render :new
    end
  end

  def update
    if @standup.update(standup_params)
      redirect_back(
        fallback_location: root_path,
        notice: "Standup was successfully updated."
      )
    else
      render :edit
    end
  end

  def destroy
    @standup = Standup.find(params[:id])
    @standup.destroy
    redirect_back(
      fallback_location: root_path,
      notice: "Standup was successfully removed."
    )
  end

  private

    def set_standup
      @standup = Standup.find(params[:id])
    end

    def standup_params
      params.require(:standup).permit(
        :standup_date,
        dids_attributes: [:id, :title, :_destroy],
        todos_attributes: [:id, :title, :_destroy],
        blockers_attributes: [:id, :title, :_destroy]
      )
    end
end
