require 'minitest/autorun'
require_relative '../lib/merchant'
require_relative '../lib/merchant_parser'
require_relative '../lib/invoice'

class MerchantTest < Minitest::Test
  def test_it_stores_an_id
    merchant = Merchant.new({:id => 6}, nil)
    assert_equal 6, merchant.id
  end

  def test_it_stores_ids_as_integers_only
    merchant = Merchant.new({:id => '6'}, nil)
    assert_equal 6, merchant.id
  end

  def test_it_stores_a_name
    merchant = Merchant.new({:name => 'John'}, nil)
    assert_equal "John", merchant.name
  end
end

class FakeMerchantRepository
  attr_accessor :invoices

  def find_invoices_by_merchant_id(id)
    @invoices
  end
end

class MerchantIntegrationTest < Minitest::Test
  def test_it_finds_related_orders
    @merchant_repo = FakeMerchantRepository.new
    data = {:name => "My Shop"}
    @merchant = Merchant.new(data, @merchant_repo)

    invoices = Array.new(5){ Invoice.new }
    @merchant_repo.invoices = invoices

    assert_equal invoices, @merchant.invoices
  end
end

class MerchantParserTest < Minitest::Test
  def test_it_parses_a_csv_of_data
    filename = "test/support/sample_merchants.csv"
    parser = MerchantParser.new(filename)
    merchants = parser.parse

    first = merchants.first
    assert_equal 1, first.id
    assert_equal "Schroeder-Jerde", first.name

    second = merchants[1]
    assert_equal 2, second.id
    assert_equal "Klein, Rempel and Jones", second.name
  end
end
