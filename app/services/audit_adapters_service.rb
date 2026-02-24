# frozen_string_literal: true

# Runs all registered parser adapters against README content, scores their results,
# and recommends the best adapter for a given awesome list.
class AuditAdaptersService
  include Dry::Monads[:result]

  def call(content:)
    return Failure('Content must be provided') if content.blank?

    adapters = ParserAdapterRegistry.all_adapters
    results = adapters.map { |adapter| audit_adapter(adapter, content) }
    results.sort_by! { |r| -r[:score] }

    Success({
      current_adapter: detect_current_adapter(content),
      recommended: results.first,
      results:
    })
  end

  private

  def audit_adapter(adapter, content)
    matches = adapter.matches?(content)
    parse_result = attempt_parse(adapter, content)

    metrics = parse_result[:success] ? compute_metrics(parse_result[:categories]) : empty_metrics
    score = compute_score(metrics, matches, parse_result[:success])

    {
      adapter_name: adapter.class.name,
      matches:,
      metrics:,
      parse_error: parse_result[:error],
      parse_success: parse_result[:success],
      priority: adapter.priority,
      score:
    }
  end

  def attempt_parse(adapter, content)
    result = adapter.parse(content)
    if result.success?
      {categories: result.value!, error: nil, success: true}
    else
      {categories: [], error: result.failure, success: false}
    end
  rescue StandardError => e
    {categories: [], error: e.message, success: false}
  end

  def compute_metrics(categories)
    return empty_metrics if categories.empty?

    item_counts = categories.map { |c| extract_items(c).size }
    total_items = item_counts.sum
    category_count = categories.size
    avg = total_items.to_f / category_count

    variance = item_counts.sum { |c| (c - avg)**2 } / category_count.to_f
    std_dev = Math.sqrt(variance)
    cv = avg > 0 ? std_dev / avg : Float::INFINITY

    {
      avg_items_per_category: avg.round(1),
      categories: categories.map { |c| {items: extract_items(c).size, name: extract_name(c)} },
      category_count:,
      coefficient_of_variation: cv.round(2),
      max_items: item_counts.max,
      min_items: item_counts.min,
      std_dev: std_dev.round(1),
      total_items:
    }
  end

  def empty_metrics
    {
      avg_items_per_category: 0,
      categories: [],
      category_count: 0,
      coefficient_of_variation: 0,
      max_items: 0,
      min_items: 0,
      std_dev: 0,
      total_items: 0
    }
  end

  # Adapters return Structs::Category (with .repos) or hashes (with :items/:repos)
  def extract_items(category)
    if category.respond_to?(:repos)
      category.repos || []
    elsif category.is_a?(Hash)
      category[:repos] || category[:items] || []
    else
      []
    end
  end

  def extract_name(category)
    if category.respond_to?(:name)
      category.name
    elsif category.is_a?(Hash)
      category[:name]
    else
      'Unknown'
    end
  end

  def compute_score(metrics, matches, parse_success)
    return 0.0 unless matches && parse_success
    return 0.0 if metrics[:total_items] == 0

    # More categories = better (log scale)
    category_score = Math.log2([metrics[:category_count], 1].max) * 20

    # Lower CV = more even distribution = better
    capped_cv = [metrics[:coefficient_of_variation], 3.0].min
    evenness_score = (1.0 - (capped_cv / 3.0)) * 30

    # More items parsed = better (diminishing returns)
    coverage_score = Math.log10([metrics[:total_items], 1].max) * 15

    # Penalty: single category strongly suggests poor parsing
    single_penalty = metrics[:category_count] == 1 ? -20 : 0

    [category_score + evenness_score + coverage_score + single_penalty, 0.0].max.round(1)
  end

  def detect_current_adapter(content)
    adapter = ParserAdapterRegistry.find_adapter(content)
    adapter&.class&.name || 'StandardAwesomeListAdapter'
  end
end
