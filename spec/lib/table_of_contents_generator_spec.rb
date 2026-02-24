# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TableOfContentsGenerator do
  describe '.generate' do
    example 'generates table of contents from category names' do
      categories = ['Alpha', 'Beta', 'Gamma']

      result = described_class.generate(categories)

      expect(result).to include('## Table of Contents')
      expect(result).to include('- [Alpha](#alpha)')
      expect(result).to include('- [Beta](#beta)')
      expect(result).to include('- [Gamma](#gamma)')
    end

    example 'handles category names with special characters' do
      categories = ['Art & Culture', 'C++ Development', 'Node.js Tools']

      result = described_class.generate(categories)

      expect(result).to include('- [Art & Culture](#art--culture)')
      expect(result).to include('- [C++ Development](#c-development)')
      expect(result).to include('- [Node.js Tools](#nodejs-tools)')
    end

    example 'handles category names with emojis' do
      categories = ['Agent Skills 🤖', 'Alternative Clients 📱']

      result = described_class.generate(categories)

      expect(result).to include('- [Agent Skills 🤖](#agent-skills-)')
      expect(result).to include('- [Alternative Clients 📱](#alternative-clients-)')
    end

    example 'preserves category order' do
      categories = ['Zebra', 'Alpha', 'Middle']

      result = described_class.generate(categories)
      lines = result.lines.map(&:strip).reject(&:empty?)

      # Find the order of categories in the output
      zebra_idx = lines.index { |l| l.include?('[Zebra]') }
      alpha_idx = lines.index { |l| l.include?('[Alpha]') }
      middle_idx = lines.index { |l| l.include?('[Middle]') }

      expect(zebra_idx).to be < alpha_idx
      expect(alpha_idx).to be < middle_idx
    end

    example 'returns empty string for empty categories' do
      result = described_class.generate([])

      expect(result).to eq('')
    end

    example 'returns empty string for nil categories' do
      result = described_class.generate(nil)

      expect(result).to eq('')
    end
  end

  describe '.slugify' do
    example 'converts category name to anchor slug' do
      expect(described_class.slugify('Hello World')).to eq('hello-world')
    end

    example 'removes special characters' do
      expect(described_class.slugify('Art & Culture')).to eq('art--culture')
      expect(described_class.slugify('C++')).to eq('c')
      expect(described_class.slugify('Node.js')).to eq('nodejs')
    end

    example 'handles emojis' do
      expect(described_class.slugify('Agent Skills 🤖')).to eq('agent-skills-')
    end

    example 'handles consecutive spaces' do
      expect(described_class.slugify('Multiple   Spaces')).to eq('multiple---spaces')
    end

    example 'downcases the result' do
      expect(described_class.slugify('UPPERCASE')).to eq('uppercase')
    end
  end
end
