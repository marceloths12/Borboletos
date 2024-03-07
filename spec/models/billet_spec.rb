require 'rails_helper'

RSpec.describe Billet, type: :model do

  describe 'validations' do
    let!(:billet) { create(:billet) }
    it { should validate_presence_of( :expire_at) }
    it { should validate_presence_of( :customer_person_name) }
    it { should validate_presence_of( :customer_city_name) }
    it { should validate_presence_of( :customer_state) }
    it { should validate_presence_of( :customer_city_name) }
    it { should validate_presence_of( :customer_zipcode) }
    it { should validate_presence_of( :customer_address) }
    it { should validate_presence_of( :customer_neighborhood) }

    it 'expire_at is a weekend' do
      billet = build(:billet, expire_at: '2026-01-03')
      expect(billet).to be_invalid
      expect(billet.errors[:expire_at]).to eq(["não pode ser no sábado ou domingo!"])
    end

    it 'if expire_at is in the past' do
      billet = build(:billet, expire_at: '2022-01-03')
      expect(billet).to be_invalid
      expect(billet.errors[:expire_at]).to eq(["não pode ser no passado!"])
    end
  end

  describe 'scopes' do
    let!(:billet1) { create(:billet, customer_person_name: 'Gon Freecss') }
    let!(:billet2) { create(:billet, customer_cnpj_cpf: '29464550090', customer_person_name: 'Van Hohenheim' ) }
    let!(:billet3) { create(:billet, expire_at: '2024-07-05', customer_person_name: 'Edward Elric')}
    let!(:billet4) { create(:billet, expire_at: '2024-07-19', customer_person_name: 'Zeno Zoldyck', customer_situation: 'Overdue')}

    context 'by_customer_person_name' do
      it 'returns the billets that have the name or a name similar to the one entered' do
        results = Billet.by_customer_person_name('Gon');
        expect(Billet.count).to eq(4)
        expect(results).to include(billet1)
        expect(results).not_to include(billet2, billet3, billet4)
      end
    end

    context 'by_customer_cnpj_cpf' do
      it 'returns the billets that have the CPF or CNPJ entered' do
        results = Billet.by_customer_cnpj_cpf('29464550090')
        expect(Billet.count).to eq(4)
        expect(results).to include(billet2)
        expect(results).not_to include(billet1, billet3, billet4)
      end
    end

    context 'by_customer_situation' do

      it 'returns the billets that are in the status reported' do
        results = Billet.by_customer_situation('Overdue')
        expect(Billet.count).to eq(4)
        expect(results).to include(billet4)
        expect(results).not_to include(billet1, billet2, billet2)
      end
    end

    context 'by_expire_at' do
      it 'returns the billets according to the informed date or period' do
        expect(Billet.count).to eq(4)
        expect(Billet.by_expire_at( nil, '2024-07-15' )).to include(billet3,billet3)
        expect(Billet.by_expire_at( '2024-07-31', nil )).to include(billet1, billet2)
        expect(Billet.by_expire_at('2024-07-01', '2024-07-31')).to include(billet3, billet4)
      end
    end
  end
end
