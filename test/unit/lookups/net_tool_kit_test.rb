# encoding: utf-8
require 'test_helper'

class NetToolKitTest < GeocoderTestCase
  def setup
    super
    Geocoder.configure(lookup: :net_tool_kit)
    set_api_key!(:net_tool_kit)
  end

  def test_query_url_contains_address_and_provider
    lookup = Geocoder::Lookup::NetToolKit.new
    url = lookup.query_url(Geocoder::Query.new('Madison Square Garden', provider: 'google'))
    assert_match(%r{https://api.nettoolkit.com/v1/geo/geocodes\?version=2&}, url)
    assert_match(/address=Madison\+Square\+Garden/, url)
    assert_match(/provider=google/, url)
  end

  def test_query_for_reverse_geocode
    lookup = Geocoder::Lookup::NetToolKit.new
    url = lookup.query_url(Geocoder::Query.new([45.423733, -75.676333]))
    assert_match(%r{reverse-geocodes}, url)
  end

  def test_result_components
    result = Geocoder.search('Madison Square Garden, New York, NY').first
    assert_equal '4 Penn Plz, New York, NY 10001, USA', result.address
    assert_equal [40.750354, -73.993371], result.coordinates
    assert_equal '4', result.house_number
    assert_equal 'Penn Plz', result.street
    assert_equal 'Penn', result.street_name
    assert_equal 'Plz', result.street_type
    assert_equal 'New York', result.city
    assert_equal 'New York County', result.county
    assert_equal 'New York', result.state
    assert_equal 'NY', result.state_code
    assert_equal '10001', result.postal_code
    assert_equal 'exact', result.precision
    assert_equal 'ntk', result.provider
    assert_equal 0.1, result.ntk_geocode_time
  end

  def test_no_results
    assert_equal [], Geocoder.search('no results')
  end

  def test_raises_exception_on_invalid_key
    Geocoder.configure(always_raise: [Geocoder::InvalidApiKey])
    assert_raises Geocoder::InvalidApiKey do
      Geocoder.search('invalid api key')
    end
  end
end
