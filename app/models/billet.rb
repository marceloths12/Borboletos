class Billet < ApplicationRecord

  validates :customer_cnpj_cpf, presence: true, length: { in: 11..14 }

  validates :expire_at,
            :customer_person_name,
            :customer_cnpj_cpf,
            :customer_city_name,
            :customer_state,
            :customer_city_name,
            :customer_zipcode,
            :customer_address,
            :customer_neighborhood,
            presence: true

  validate :verify_expire_at
  validate :validar_cpf_ou_cnpj

  after_create :generate_billet
  after_update :update_billet

  scope :by_customer_person_name, ->(name) { where('customer_person_name ILIKE ?', "%#{name}%") if name.present? }
  scope :by_customer_cnpj_cpf, ->(cnpj_cpf) { where('customer_cnpj_cpf LIKE ?', "#{cnpj_cpf}%") if cnpj_cpf.present? }
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

  def generate_billet
    KobanaJob.perform_now('post', self)
  end

  def update_billet
    KobanaJob.perform_now('put', self)
  end

  def validar_cpf_ou_cnpj
    unless check_cpf(customer_cnpj_cpf) || check_cnpj(customer_cnpj_cpf)
      errors.add(:customer_cnpj_cpf, :invalid_cnpj_cpf)
    end
  end

  def verify_expire_at
    if  expire_at.present?
      errors.add(:expire_at, :previous_date) if Date.today > expire_at
      errors.add(:expire_at, :weekend) if [0, 6].include?(expire_at.wday)
    end
  end

  def check_cpf(cpf=nil)
    return false if cpf.nil?

    nulos = %w{12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000 12345678909}
    valor = cpf.scan /[0-9]/
    if valor.length == 11
      unless nulos.member?(valor.join)
        valor = valor.collect{|x| x.to_i}
        soma = 10*valor[0]+9*valor[1]+8*valor[2]+7*valor[3]+6*valor[4]+5*valor[5]+4*valor[6]+3*valor[7]+2*valor[8]
        soma = soma - (11 * (soma/11))
        resultado1 = (soma == 0 or soma == 1) ? 0 : 11 - soma
        if resultado1 == valor[9]
          soma = valor[0]*11+valor[1]*10+valor[2]*9+valor[3]*8+valor[4]*7+valor[5]*6+valor[6]*5+valor[7]*4+valor[8]*3+valor[9]*2
          soma = soma - (11 * (soma/11))
          resultado2 = (soma == 0 or soma == 1) ? 0 : 11 - soma
          return true if resultado2 == valor[10] # CPF válido
        end
      end
    end
    return false
  end

  def check_cnpj(cnpj=nil)
    return false if cnpj.nil?

    nulos = %w{11111111111111 22222222222222 33333333333333 44444444444444 55555555555555 66666666666666 77777777777777 88888888888888 99999999999999 00000000000000}
    valor = cnpj.scan /[0-9]/
    if valor.length == 14
      unless nulos.member?(valor.join)
        valor = valor.collect{|x| x.to_i}
        soma = valor[0]*5+valor[1]*4+valor[2]*3+valor[3]*2+valor[4]*9+valor[5]*8+valor[6]*7+valor[7]*6+valor[8]*5+valor[9]*4+valor[10]*3+valor[11]*2
        soma = soma - (11*(soma/11))
        resultado1 = (soma==0 || soma==1) ? 0 : 11 - soma
        if resultado1 == valor[12]
          soma = valor[0]*6+valor[1]*5+valor[2]*4+valor[3]*3+valor[4]*2+valor[5]*9+valor[6]*8+valor[7]*7+valor[8]*6+valor[9]*5+valor[10]*4+valor[11]*3+valor[12]*2
          soma = soma - (11*(soma/11))
          resultado2 = (soma == 0 || soma == 1) ? 0 : 11 - soma
          return true if resultado2 == valor[13] # CNPJ válido
        end
      end
    end
    return false
  end
end
