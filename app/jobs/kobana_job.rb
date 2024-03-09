class KobanaJob < ApplicationJob
  queue_as :default

  BASE_URL = 'https://api-sandbox.kobana.com.br/v1/bank_billets'.freeze

  ACTION_METHOD_MAP = {
    'get' => :perform_get,
    'post' => :perform_post,
    'put' => :perform_put,
    'delete' => :perform_delete,
    'update_base' => :perform_update_billets
  }.freeze

  def perform(method, billet=nil)
    send(ACTION_METHOD_MAP[method.downcase], billet)
  end

  private

  def perform_get(_data)
    perform_request(url, Net::HTTP::Get)
  end

  def perform_post(billet)
    object = JSON.parse(billet.to_json).compact

    response = perform_request(BASE_URL, Net::HTTP::Post, object)
    result = JSON.parse(response.body).compact

    billet.update(external_id: result['id'], customer_situation: result['status'])
  end

  def perform_put(data)
    url = "#{BASE_URL}/#{data['external_id']}"

    perform_request(url, Net::HTTP::Put, { 'amount': data.amount.to_f, 'expire_at': data.expire_at.to_s })
  end

  def perform_delete(_data)
    url = "#{BASE_URL}/#{data['external_id']}"

    perform_request(url, Net::HTTP::Delete, {'cancellation_reason': 1})
  end

  def perform_update_billets(_data)
    response = perform_request(BASE_URL, Net::HTTP::Get)
    result = JSON.parse(response.body).compact
    result.each do |response_billet|
      billet = Billet.find_by(external_id: response_billet['id'])
      return if billet.nil?
      billet.update({expire_at: response_billet['expire_at'], customer_situation: response_billet['status'], amount: response_billet['amount']})
    end
  end

  def perform_request(url, request_class, data = nil)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = request_class.new(uri)
    request.body = data.to_json if data

    set_common_request_headers(request)

    response = http.request(request)

    response
  end

  def set_common_request_headers(request)
    request['accept'] = 'application/json'
    request['content-type'] = 'application/json'
    request['authorization'] = "Bearer #{ENV['kobana_token']}"
  end
end
