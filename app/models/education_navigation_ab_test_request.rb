class EducationNavigationAbTestRequest
  attr_accessor :requested_variant

  delegate :analytics_meta_tag, to: :requested_variant

  def initialize(request:, content_item:)
    @content_item = content_item
    @ab_test = GovukAbTesting::AbTest.new('EducationNavigation', dimension: 41)
    @requested_variant = @ab_test.requested_variant(request.headers)
  end

  def ab_test_applies?
    content_is_tagged_to_a_taxon?
  end

  def should_present_new_navigation_view?
    ab_test_applies? && @requested_variant.variant_b?
  end

  def set_response_vary_header(response)
    @requested_variant.configure_response response
  end

private

  def content_is_tagged_to_a_taxon?
    @content_item.dig('links', 'taxons').present?
  end
end
