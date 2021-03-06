class InfluencerProjectsController < ApplicationController
  before_action :authenticate_company!, only: [:new, :create, :completion]
  before_action :authenticate_influencer!, only: [:index, :show, :update]
  layout 'company'

  def index
    @influencer_projects = InfluencerProject.where(influencer_id: current_influencer.id)
    if company_signed_in?
      render :layout => 'company'
    else
      render :layout => 'influencer'
    end
  end

  def new
    @influencer_project = InfluencerProject.new
    @influencer = Influencer.find(params[:influencer_id])
  end

  def show
    @statuses = InfluencerProject.statuses.map do |key, value|
      if key == "rejection" || key == "approval"
        [I18n.t("enums.influencer_project.status.#{key}"), value]
      end
    end.compact!
    @influencer_project = InfluencerProject.find(params[:id])
    if current_influencer && current_influencer.id == @influencer_project.influencer_id
      @influencer_project.checked = true
      @influencer_project.save
    elsif current_company && current_company.id == @influencer_project.company_id
      @influencer_project.company_checked = true
      @influencer_project.save
    end
    if company_signed_in?
      render :layout => 'company'
    else
      render :layout => 'influencer'
    end
  end

  def update
    @influencer_project = InfluencerProject.find(params[:id])
    @influencer_project.update(status: params[:influencer_project][:status].to_i, influencer_message: params[:influencer_project][:influencer_message])
    flash[:success] = '送信完了です！'
    redirect_to influencers_path
  end

  def completion
    @influencer_project = InfluencerProject.find_by(influencer_id: params[:influencer_id], project_id: params[:id])
    @influencer_project.completion!
    redirect_to @influencer_project.project
  end

  def create
    influencer_project = InfluencerProject.new(influencer_project_params)
    influencer_project.status = 0
    if influencer_project.save
      flash[:success] = '送信完了です！'
      redirect_to companies_path
    else
      @influencer = influencer_project.influencer
      flash[:success] = '送信失敗です。。'
      render "new"
    end
  end

  private

  def influencer_project_params
    params.permit(:message, :influencer_id, :project_id, :influencer_message)
  end
end
