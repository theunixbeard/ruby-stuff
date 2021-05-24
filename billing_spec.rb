# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Billing, type: :service do
  let!(:user) { create(:user) }

  before do
    stripe_stubs
  end

  describe 'update_credit_card' do
    context 'not already added' do
      it 'adds credit card' do
        expect { Billing::UpdateCreditCard.run(user, 'tok_visa') }.to change { user.credit_cards.count }.by(1)
      end

      it 'returns credit card' do
        expect(Billing::UpdateCreditCard.run(user, 'tok_visa')[:credit_card]).not_to be nil
      end
    end

    context 'already added' do
      let!(:credit_card) do
        create(:credit_card, user: user, fingerprint: 'tmCyMTBTI0eu1cNF')
      end

      it "doesn't add card" do
        expect { Billing::UpdateCreditCard.run(user, 'tok_visa') }.not_to change { user.credit_cards.count }
      end

      it 'returns credit card' do
        expect(Billing::UpdateCreditCard.run(user, 'tok_visa')[:credit_card]).not_to be nil
      end
    end
  end
end

