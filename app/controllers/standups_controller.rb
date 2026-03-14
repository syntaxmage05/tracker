# frozen_string_literal: true

class StandupsController < ApplicationController
  before_action :set_standup, only: %i[ show edit update destroy ]

  # GET /standups or /standups.json
  def index
    @standups = Standup.all
  end

  # GET /standups/1 or /standups/1.json
  def show
  end

  # GET /standups/new
  def new
    @standup = Standup.new
  end

  # GET /standups/1/edit
  def edit
  end

  # POST /standups or /standups.json
  def create
    @standup = Standup.new(standup_params)

    respond_to do |format|
      if @standup.save
        format.html { redirect_to @standup, notice: "Standup was successfully created." }
        format.json { render :show, status: :created, location: @standup }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @standup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /standups/1 or /standups/1.json
  def update
    respond_to do |format|
      if @standup.update(standup_params)
        format.html { redirect_to @standup, notice: "Standup was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @standup }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @standup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /standups/1 or /standups/1.json
  def destroy
    @standup.destroy!

    respond_to do |format|
      format.html { redirect_to standups_path, notice: "Standup was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_standup
      @standup = Standup.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def standup_params
      params.expect(standup: [ :user_id, :standup_date ])
    end
end
