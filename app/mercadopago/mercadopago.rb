# MercadoPago Integration Library
# Access MercadoPago for payments integration
#
# @author @maticompiano
# @contributors @chrismo

require 'rubygems'
require 'json/add/core'
require 'uri'
require 'net/https'
require 'yaml'
require 'version'

class MercadoPago
  def initialize(client_id, client_secret, debug_logger=nil)
    @client_id = client_id
    @client_secret = client_secret
    @rest_client = RestClient.new(debug_logger)
    @sandbox = false
  end

  def set_debug_logger(debug_logger)
    @rest_client.set_debug_logger(debug_logger)
  end

  def sandbox_mode(enable=nil)
    if not enable.nil?
      @sandbox = enable
    end

    return @sandbox
  end

  # Get Access Token for API use
  def get_access_token
    app_client_values = {
      'grant_type' => 'client_credentials',
      'client_id' => @client_id,
      'client_secret' => @client_secret
    }

    @access_data = @rest_client.post("/oauth/token", build_query(app_client_values), RestClient::MIME_FORM)

    if @access_data['status'] == "200"
      @access_data = @access_data["response"]
      @access_data['access_token']
    else
      raise @access_data.inspect
    end
  end

  # Get information for specific payment
  def get_payment(id)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    uri_prefix = @sandbox ? "/sandbox" : ""
    @rest_client.get(uri_prefix + "/collections/notifications/" + id + "?access_token=" + access_token)
  end

  def get_payment_info(id)
    get_payment(id)
  end

  # Get information for specific authorized payment
  def get_authorized_payment(id)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    @rest_client.get("/authorized_payments/" + id + "?access_token=" + access_token)
  end

  # Refund accredited payment
  def refund_payment(id)
    manage_collections(id, 'refunded', 'collections')
  end

  # Cancel pending payment
  def cancel_payment(id)
    manage_collections(id, 'cancelled', 'collections')
  end

  # Cancel preapproval payment
  def cancel_preapproval_payment(id)
    manage_collections(id, 'cancelled', 'preapproval')
  end

  # Search payments according to filters, with pagination
  def search_payment(filters, offset=0, limit=0)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    filters["offset"] = offset
    filters["limit"] = limit

    filters = build_query(filters)

    uri_prefix = @sandbox ? "/sandbox" : ""
    @rest_client.get(uri_prefix + "/collections/search?" + filters + "&access_token=" + access_token)
  end

  # Create a checkout preference
  def create_preference(preference)
    submit_object(preference, '/checkout/preferences')
  end

  # Update a checkout preference
  def update_preference(id, preference)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    @rest_client.put("/checkout/preferences/" + id + "?access_token=" + access_token, preference)
  end

  # Get a checkout preference
  def get_preference(id)
    fetch_by_id(id, '/checkout/preferences/')
  end

  # Create a preapproval payment
  def create_preapproval_payment(preapproval_payment)
    submit_object(preapproval_payment, '/preapproval')
  end

  # Get a preapproval payment
  def get_preapproval_payment(id)
    fetch_by_id(id, '/preapproval/')
  end

  def build_query(params)
    URI.escape(params.collect { |k, v| "#{k}=#{v}" }.join('&'))
  end

  private

  def manage_collections(id, status, type)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    collection_status = { 'status' => status }
    @rest_client.put("/#{type}/#{id}?access_token=#{access_token}", collection_status)
  end

  def submit_object(object, url)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    @rest_client.post("#{url}?access_token=#{access_token}", object)
  end

  def fetch_by_id(id, url)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    @rest_client.get("#{url}#{id}?access_token=#{access_token}")
  end

  class RestClient

    MIME_JSON = 'application/json'
    MIME_FORM = 'application/x-www-form-urlencoded'
    API_BASE_URL = URI.parse('https://api.mercadolibre.com')

    def initialize(debug_logger=nil)
      @http = Net::HTTP.new(API_BASE_URL.host, API_BASE_URL.port)

      if API_BASE_URL.scheme == "https" # enable SSL/TLS
        @http.use_ssl = true
        @http.ssl_version = :SSLv23 if @http.respond_to? :ssl_version
        @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        @http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end

      @http.set_debug_output debug_logger if debug_logger
    end

    def set_debug_logger(debug_logger)
      @http.set_debug_output debug_logger
    end

    def exec(method, uri, data, content_type)
      if not data.nil? and content_type == MIME_JSON
        data = data.to_json
      end

      headers = {
        'User-Agent' => "MercadoPago Ruby SDK v" + MERCADO_PAGO_VERSION,
        'Content-type' => content_type,
        'Accept' => MIME_JSON
      }

      api_result = @http.send_request(method, uri, data, headers)

      {
        "status" => api_result.code,
        "response" => JSON.parse(api_result.body)
      }
    end

    def get(uri, content_type=MIME_JSON)
      exec("GET", uri, nil, content_type)
    end

    def post(uri, data = nil, content_type=MIME_JSON)
      exec("POST", uri, data, content_type)
    end

    def put(uri, data = nil, content_type=MIME_JSON)
      exec("PUT", uri, data, content_type)
    end
  end
end
