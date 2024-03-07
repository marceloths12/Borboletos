class Billet < ApplicationRecord
  validates :expire_at, :customer_person_name, :customer_city_name,
    :customer_state, :customer_city_name, :customer_zipcode, :customer_address,
    :customer_neighborhood, presence: :true
  validates :external_id, presence: :true, unless: :new_record?

  validate :verify_expire_at

  scope :by_customer_person_name, ->(name) { where('billets.customer_person_name ILIKE ?', "%#{name}%") if name.present? }

  scope :by_customer_cnpj_cpf, ->(cnpj_cpf) {where('billets.customer_cnpj_cpf LIKE ?', "#{cnpj_cpf}%") if cnpj_cpf.present? }

  scope :by_customer_situation, ->(situation) { where(customer_situation: situation) if situation.present? }

  scope :by_expire_at, ->(start_expire_at, end_expire_at) do
    if(start_expire_at.present? && end_expire_at.present?)
      where(expire_at: (start_expire_at..end_expire_at))
    elsif start_expire_at.present?
      where('billets.expire_at >= ?', start_expire_at)
    elsif end_expire_at.present?
      where('billets.expire_at <= ?', end_expire_at)
    end
  end

  scope :ordered, -> { order(expire_at: :desc) }


  def self.search(search_params)
    by_customer_person_name(search_params[:customer_person_name])
      .merge(by_customer_cnpj_cpf(search_params[:customer_cnpj_cpf]))
      .merge(by_expire_at(search_params[:start_expire_at], search_params[:end_expire_at]))
      .merge(by_customer_situation(search_params[:customer_situation]))
      .ordered
  end

  private

  def verify_expire_at
    if  expire_at.present?
      errors.add(:expire_at, :previous_date) if Date.today > expire_at
      errors.add(:expire_at, :weekend) if [0, 6].include?(expire_at.wday)
    end
  end
end
