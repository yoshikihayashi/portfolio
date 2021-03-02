class CompanyReviewsController < ApplicationController
   layout 'influencer'
  def new
    @company_review = CompanyReview.new
    if influencer_signed_in?
      render :layout => 'influencer'
    else
      render :layout => 'company'
    end
  end

  def create
    project_id = InfluencerProject.find(params[:id]).project_id
    company_id = Project.find(project_id).company_id
    @company_review = CompanyReview.new(company_review_params)
    @company_review.company_id = company_id
    if @company_review.save
      # InfluencerProject.find_by(project_id: project.id, company_id: company.id).update!(status: 4)
      flash[:success] = '送信しました！'
      redirect_to influencer_projects_path(current_influencer.id)
    else
      flash[:success] = '送信失敗しました。。。'
      render 'new'
    end

  end

  private

  def company_review_params
    params.require(:company_review).permit(:rate,:comment, :company_id)
  end
end
