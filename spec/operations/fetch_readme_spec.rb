# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/operations/fetch_readme'

RSpec.describe Operations::FetchReadme, type: :operation do
  include Test::Support::VCR

  let(:repo_name) { 'awesome-selfhosted/awesome-selfhosted' }
  let(:expected_path) { "tmp/awesome-selfhosted__awesome-selfhosted.md" }

  it 'fetches the README from GitHub and saves it to tmp, using VCR', :decode_content do
    vcr('github', 'fetch_readme_awesome_selfhosted') do
      result = described_class.call(repo_name:)
      expect(result).to be_success
      file_path = result.value!
      expect(file_path).to eq(expected_path)
      expect(File).to exist(file_path)
      expect(File.read(file_path)).to include('awesome-selfhosted')
    end
  end
end
