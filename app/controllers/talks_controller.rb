class TalksController < ApplicationController
  before_action :authenticate_user!, only: [
    :new, :create, :edit, :assign, :unassign, :upvote
  ]
  before_action :find_talk, only: [:show, :edit, :update, :destroy]

  def index
    @unscheduled_talks = Talk.unscheduled
    @scheduled_talks = Talk.scheduled
    @previous_talks = Talk.previous
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = current_user.talks.create(talk_params)
    if @talk.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @talk.update_attributes(talk_params)
    redirect_to root_path
  end

  def destroy
    @talk.destroy
    redirect_to root_path
  end

  def upvote
    talk = Talk.find(params[:id])
    current_user.upvote(talk)
    redirect_to(talks_path)
  end

  def assign
    talk = Talk.find(params[:id])
    current_user.assign(talk)
    redirect_to(talks_path)
  end

  def unassign
    talk = Talk.find(params[:id])
    current_user.unassign(talk)
    redirect_to(talks_path)
  end

  private

  def find_talk
    @talk = Talk.find(params[:id])
  end

  def talk_params
    params.require(:talk).permit(:topic, :description, :speak_date)
  end
end
