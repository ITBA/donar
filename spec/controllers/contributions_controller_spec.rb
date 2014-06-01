require 'spec_helper'

describe ContributionsController do

  let(:organization) { create(:organization) }
  let(:campaign) { create(:campaign, organization: organization) }
  let(:contribution) { attributes_for(:contribution) }
  let(:user) { create(:user, organizations: [organization]) }

  describe 'POST create' do

    context 'When creating a contribution correctly for a campaign' do

      before(:each) do
        sign_in(user)
        user.reload
      end

      it 'assigns the campaign to the contribution' do
        post :create,
             organization_id: organization.id,
             campaign_id: campaign.id,
             contribution: contribution
        expect(Contribution.last.campaign).to eq campaign
      end

      # removed the test that was here because it no longer redirects you yo the campaign path
      # it redirects you to mercadopago

      it 'creates the contribution' do
        expect do
          post :create,
               organization_id: organization.id,
               campaign_id: campaign.id,
               contribution: contribution
        end.to change(Contribution, :count).by(1)
      end

      it 'adds the amount to the campaign' do
        expect do
          post :create,
               organization_id: organization.id,
               campaign_id: campaign.id,
               contribution: contribution
          campaign.reload
        end.to change(campaign, :contribution).by(contribution[:amount])
      end

    end

  end

end
