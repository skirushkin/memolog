# frozen_string_literal: true

describe Memolog do
  describe "#configure" do
    it "can change configuration" do
      described_class.configure do |config|
        config.initializers = []
        config.log_size_limit = 1
      end

      expect(described_class.config.initializers).to eq([])
      expect(described_class.config.log_size_limit).to eq(1)

      described_class.configure do |config|
        config.initializers = %i[rails sentry sidekiq]
        config.log_size_limit = 50_000
      end
    end
  end

  describe "#dump", :with_other_logger do
    it "supports #info, #debug, #etc with #run" do
      Memolog.run do
        other_logger.info("hello")
        expect(Memolog.dump).to include(Memolog.uuid)
        expect(Memolog.dump).to include("hello")
      end

      expect(Memolog.dump).to be_nil
    end

    it "supports #log" do
      Memolog.run do
        other_logger.log(0, "hello")
        expect(Memolog.dump).to include(Memolog.uuid)
        expect(Memolog.dump).to include("hello")
      end
    end

    it "return nil without #run" do
      other_logger.info("hello")
      expect { Memolog.dump }.not_to raise_error
      expect(Memolog.dump).to be_nil
    end

    it "saves log with debug option" do
      Memolog.configure { |config| config.debug = true }
      Memolog.run { other_logger.info("hello") }
      expect(Memolog.dump).to include("hello")

      Memolog.configure { |config| config.debug = false }
      Memolog.logdevs.pop
    end
  end
end

describe Memolog::RailsMiddleware do
  let(:app) { double(:app) }
  let(:env) { double(:env) }

  it "behaves like middleware" do
    expect(app).to receive(:call).with(env)
    described_class.new(app).call(env)
  end

  it "starts memolog for app", :with_other_logger do
    expect(app).to receive(:call) do
      other_logger.info("hello")
      expect(Memolog.dump).to include("hello")
    end

    described_class.new(app).call(env)
  end
end

describe Memolog::Init do
  describe "#init_rails_middleware!" do
    it "insert middleware to Rails.application" do
      make_rails_app { described_class.new.send(:init_rails_middleware!) }
      expect(Rails.application.middleware[0]).to eq(Memolog::RailsMiddleware)
    end
  end

  describe "#init_sidekiq_middleware!" do
    let(:worker) { double(:worker) }
    let(:job) { double(:job) }
    let(:queue) { double(:queue) }

    it "insert middleware to Sidekiq" do
      described_class.new.send(:init_sidekiq_middleware!)
      expect(Memolog).to receive(:run)

      Memolog::SidekiqMiddleware.new.call(worker, job, queue)
    end
  end
end
