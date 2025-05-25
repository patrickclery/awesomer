# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubRateLimiterService do
  let(:redis_client) { instance_double(Redis) }
  let(:service) { described_class.new(redis_client:) }
  let(:current_time) { Time.current.to_i }

  before do
    allow(Time).to receive(:current).and_return(Time.at(current_time))
  end

  describe '#can_make_request?' do
    context 'when under rate limit' do
      before do
        allow(redis_client).to receive(:zremrangebyscore)
        allow(redis_client).to receive(:zcard).and_return(100)
      end

      it 'returns true' do
        expect(service.can_make_request?).to be(true)
      end
    end

    context 'when at rate limit' do
      before do
        allow(redis_client).to receive(:zremrangebyscore)
        allow(redis_client).to receive(:zcard).and_return(4000)
      end

      it 'returns false' do
        expect(service.can_make_request?).to be(false)
      end
    end

    context 'when Redis is down' do
      before do
        allow(redis_client).to receive(:zremrangebyscore).and_raise(Redis::BaseError)
      end

      it 'allows the request and logs error' do
        expect(Rails.logger).to receive(:error).with(/Redis error/)
        expect(service.can_make_request?).to be(true)
      end
    end
  end

  describe '#record_request' do
    it 'records a successful request' do
      expect(redis_client).to receive(:zadd)
      expect(redis_client).to receive(:expire)

      result = service.record_request(success: true)
      expect(result).to be_success
    end

    context 'when Redis is down' do
      before do
        allow(redis_client).to receive(:zadd).and_raise(Redis::BaseError)
      end

      it 'returns success and logs error' do
        expect(Rails.logger).to receive(:error).with(/Redis error/)

        result = service.record_request
        expect(result).to be_success
      end
    end
  end

  describe '#requests_remaining' do
    context 'when under rate limit' do
      before do
        allow(redis_client).to receive(:zremrangebyscore)
        allow(redis_client).to receive(:zcard).and_return(100)
      end

      it 'returns correct remaining count' do
        expect(service.requests_remaining).to eq(3900)
      end
    end

    context 'when Redis is down' do
      before do
        allow(redis_client).to receive(:zremrangebyscore).and_raise(Redis::BaseError)
      end

      it 'returns full capacity' do
        expect(Rails.logger).to receive(:error).with(/Redis error/)
        expect(service.requests_remaining).to eq(4000)
      end
    end
  end

  describe '#time_until_reset' do
    context 'when there are requests in window' do
      let(:oldest_timestamp) { current_time - 1800 } # 30 minutes ago

      before do
        allow(redis_client).to receive(:zrange)
          .and_return([ [ "request_id", oldest_timestamp ] ])
      end

      it 'returns time until oldest request expires' do
        expected_time = oldest_timestamp + 3600 - current_time
        expect(service.time_until_reset).to eq(expected_time)
      end
    end

    context 'when no requests in window' do
      before do
        allow(redis_client).to receive(:zrange).and_return([])
      end

      it 'returns 0' do
        expect(service.time_until_reset).to eq(0)
      end
    end

    context 'when Redis is down' do
      before do
        allow(redis_client).to receive(:zrange).and_raise(Redis::BaseError)
      end

      it 'returns 0 and logs error' do
        expect(Rails.logger).to receive(:error).with(/Redis error/)
        expect(service.time_until_reset).to eq(0)
      end
    end
  end
end
