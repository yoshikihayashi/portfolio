class InfluencersController < ApplicationController
  before_action :set_influencer, only: [:show, :edit, :update]
  layout 'influencer'

  def index
    @projects = Project.all
  end

  def show
    if influencer_signed_in?
      render :layout => 'influencer'
    else
      render :layout => 'company'
    end
  end

  def edit
  end

  def update
    if @influencer.update(influencer_params)
      flash[:success] = 'プロフィールを更新しました！'
      redirect_to influencer_path(@influencer.id)
    else
      render 'edit'
    end
  end

  private

  def set_influencer
    @influencer = Influencer.find(params[:id])
  end

  def influencer_params
    params.require(:influencer).permit(:nickname, :image, :details, :name_kana, :address, :tag_ids, :follower_count, :phone_number, :name)
  end
end
