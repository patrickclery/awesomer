# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuditAdaptersService do
  let(:service) { described_class.new }

  describe '#call' do
    context 'with standard awesome list content' do
      let(:content) do
        <<~MD
          ## Category A
          - [Item1](https://github.com/user/repo1) - Description one
          - [Item2](https://github.com/user/repo2) - Description two
          - [Item3](https://github.com/user/repo3) - Description three

          ## Category B
          - [Item4](https://github.com/user/repo4) - Description four
          - [Item5](https://github.com/user/repo5) - Description five

          ## Category C
          - [Item6](https://github.com/user/repo6) - Description six
          - [Item7](https://github.com/user/repo7) - Description seven
          - [Item8](https://github.com/user/repo8) - Description eight
        MD
      end

      example 'returns Success with results for all registered adapters' do
        result = service.call(content:)
        expect(result).to be_success
        adapter_count = ParserAdapterRegistry.all_adapters.size
        expect(result.value![:results].size).to eq(adapter_count)
      end

      example 'recommends an adapter name' do
        result = service.call(content:)
        expect(result.value![:recommended]).to be_a(Hash)
        expect(result.value![:recommended][:adapter_name]).to be_present
      end

      example 'identifies the current priority-based adapter' do
        result = service.call(content:)
        expect(result.value![:current_adapter]).to eq('StandardAwesomeListAdapter')
      end

      example 'scores matching adapters higher than non-matching ones' do
        result = service.call(content:)
        results = result.value![:results]
        matching = results.select { |r| r[:matches] }
        non_matching = results.reject { |r| r[:matches] }
        next if non_matching.empty?

        expect(matching.map { |r| r[:score] }.max).to be > non_matching.map { |r| r[:score] }.max
      end
    end

    context 'with blank content' do
      example 'returns Failure for empty string' do
        expect(service.call(content: '')).to be_failure
      end

      example 'returns Failure for nil' do
        expect(service.call(content: nil)).to be_failure
      end
    end

    context 'with scoring heuristic' do
      let(:multi_category_content) do
        <<~MD
          ## Cat A
          - [I1](https://github.com/u/r1) - D
          - [I2](https://github.com/u/r2) - D
          - [I3](https://github.com/u/r3) - D

          ## Cat B
          - [I4](https://github.com/u/r4) - D
          - [I5](https://github.com/u/r5) - D
          - [I6](https://github.com/u/r6) - D
        MD
      end

      let(:single_category_content) do
        <<~MD
          ## Everything
          - [I1](https://github.com/u/r1) - D
          - [I2](https://github.com/u/r2) - D
          - [I3](https://github.com/u/r3) - D
          - [I4](https://github.com/u/r4) - D
          - [I5](https://github.com/u/r5) - D
          - [I6](https://github.com/u/r6) - D
        MD
      end

      example 'scores multiple even categories higher than single category' do
        multi_result = service.call(content: multi_category_content)
        single_result = service.call(content: single_category_content)

        multi_std = multi_result.value![:results].find { |r| r[:adapter_name] == 'StandardAwesomeListAdapter' }
        single_std = single_result.value![:results].find { |r| r[:adapter_name] == 'StandardAwesomeListAdapter' }

        expect(multi_std[:score]).to be > single_std[:score]
      end
    end
  end
end
