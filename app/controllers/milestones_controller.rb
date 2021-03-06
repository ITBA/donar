class MilestonesController < ApplicationController

  inherit_resources

  before_action :authenticate_user!
  nested_belongs_to :organization, :campaign

  FIELDS = [:description, :file, :file_extension]

  def achieve
    @milestone = Milestone.find(params[:id])
  end

  def confirm_achieved
    @milestone = Milestone.find(params[:id])
    @milestone.achieve
    if params[:milestone][:file].present?
      @milestone.file_extension = File.extname(params[:milestone][:file].original_filename)
    end
    @milestone.update_attributes!(resource_params.first)
    redirect_to organization_campaign_path(@milestone.campaign.organization, @milestone.campaign),
                notice: t('campaigns.milestone_achieved')
  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:milestone).permit(FIELDS)]
  end
end
