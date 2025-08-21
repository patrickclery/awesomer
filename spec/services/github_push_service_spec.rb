# frozen_string_literal: true

require "rails_helper"

RSpec.describe GithubPushService do
  let(:service) { described_class.new(commit_message:, files_changed:) }
  let(:files_changed) { [ "static/md/awesome-ruby.md", "static/md/awesome-python.md" ] }
  let(:commit_message) { nil }

  describe "#call" do
    context "when git operations succeed" do
      before do
        allow(Dir).to receive(:exist?).with(".git").and_return(true)
        allow(File).to receive(:exist?).and_return(true)
        allow(service).to receive(:`).and_return("main", "", "abc123def456", "", "")
        allow($?).to receive(:success?).and_return(true)
      end

      it "stages all changed files" do
        files_changed.each do |file|
          expect(service).to receive(:`).with("git add #{file}")
        end
        service.call
      end

      it "creates a commit" do
        expect(service).to receive(:`).with(/git commit -m/)
        service.call
      end

      it "uses custom message when provided" do
        service = described_class.new(commit_message: "Custom commit message", files_changed:)
        allow(Dir).to receive(:exist?).with(".git").and_return(true)
        allow(File).to receive(:exist?).and_return(true)
        allow(service).to receive(:`).and_return("main", "", "abc123def456", "", "")
        allow($?).to receive(:success?).and_return(true)

        expect(service).to receive(:`).with(/Custom commit message/)
        service.call
      end

      it "pushes to origin" do
        expect(service).to receive(:`).with(/git push origin/)
        service.call
      end

      it "returns success with commit details" do
        result = service.call

        expect(result).to be_success
        expect(result.value![:commit_sha]).to eq("abc123def456")
        expect(result.value![:files_count]).to eq(2)
        expect(result.value![:branch]).to eq("main")
      end

      it "updates last_pushed_at for synced lists" do
        awesome_list = create(:awesome_list, github_repo: "sindresorhus/awesome-ruby", last_synced_at: 1.hour.ago)

        expect {
          service.call
        }.to change { awesome_list.reload.last_pushed_at }.from(nil)
      end
    end

    context "when not in a git repository" do
      before do
        allow(Dir).to receive(:exist?).with(".git").and_return(false)
      end

      it "returns failure with appropriate message" do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to eq("Not in a git repository")
      end
    end

    context "when no files are changed" do
      let(:files_changed) { [] }

      it "returns failure with appropriate message" do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to eq("No files to push")
      end
    end

    context "when files do not exist" do
      before do
        allow(Dir).to receive(:exist?).with(".git").and_return(true)
        allow(File).to receive(:exist?).and_return(false)
        allow(service).to receive(:`).and_return("main", "")
      end

      it "skips non-existent files" do
        files_changed.each do |file|
          expect(service).not_to receive(:`).with("git add #{file}")
        end
        service.call
      end
    end

    context "when commit fails" do
      before do
        allow(Dir).to receive(:exist?).with(".git").and_return(true)
        allow(File).to receive(:exist?).and_return(true)
        allow(service).to receive(:`).and_return("main", "", "error message")
        allow($?).to receive(:success?).and_return(false)
      end

      it "returns failure with error message" do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to include("Failed to create commit")
      end
    end

    context "when push fails" do
      before do
        allow(Dir).to receive(:exist?).with(".git").and_return(true)
        allow(File).to receive(:exist?).and_return(true)

        success_counter = 0
        allow($?).to receive(:success?) do
          success_counter += 1
          success_counter == 1 # First call (commit) succeeds, second (push) fails
        end

        allow(service).to receive(:`).and_return("main", "", "", "abc123", "push error")
      end

      it "returns failure with error message" do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to include("Failed to push to GitHub")
      end

      it "resets the commit" do
        expect(service).to receive(:`).with("git reset HEAD~1")
        service.call
      end
    end

    context "when no changes in static/ directory" do
      before do
        allow(Dir).to receive(:exist?).with(".git").and_return(true)
        allow(service).to receive(:`).with("git rev-parse --abbrev-ref HEAD").and_return("main")
        allow(service).to receive(:`).with("git status --porcelain static/").and_return("")
      end

      it "returns success without committing" do
        result = service.call

        expect(result).to be_success
        expect(result.value!).to eq("No changes to push")
      end
    end

    context "when an unexpected error occurs" do
      before do
        allow(Dir).to receive(:exist?).and_raise(StandardError, "Unexpected error")
      end

      it "returns failure with the error message" do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to include("Unexpected error")
      end
    end
  end

  describe "#generate_commit_message" do
    context "with single file" do
      let(:files_changed) { [ "static/md/awesome-ruby.md" ] }

      it "generates a message for single file" do
        allow(Time).to receive(:current).and_return(Time.new(2025, 8, 21, 10, 30))
        expect(service.send(:generate_commit_message)).to include("awesome-ruby")
      end
    end

    context "with multiple files" do
      it "generates a message for multiple files" do
        allow(Time).to receive(:current).and_return(Time.new(2025, 8, 21, 10, 30))
        expect(service.send(:generate_commit_message)).to include("2 awesome lists")
      end
    end
  end
end
