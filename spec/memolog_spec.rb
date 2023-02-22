# frozen_string_literal: true

describe Memolog do
  describe "#configure" do
    it "can change configuration" do
      described_class.configure do |config|
        config.middlewares = []
        config.log_size_limit = 1
      end

      expect(described_class.config.middlewares).to eq([])
      expect(described_class.config.log_size_limit).to eq(1)

      described_class.configure do |config|
        config.middlewares = %i[rails sidekiq]
        config.log_size_limit = 50_000
      end
    end
  end

  describe "#dump", :with_other_logger do
    it "supports #info, #debug, #etc with #run" do
      described_class.run do
        other_logger.info("hello")
        expect(described_class.dump).to include("hello")
      end

      expect(described_class.dump).to be_nil
    end

    it "supports #log" do
      described_class.run do
        other_logger.log(0, "hello")
        expect(described_class.dump).to include("hello")
      end
    end

    it "return nil without #run" do
      other_logger.info("hello")
      expect { described_class.dump }.not_to raise_error
      expect(described_class.dump).to be_nil
    end

    it "saves log with debug option" do
      described_class.configure { |config| config.debug = true }
      described_class.run { other_logger.info("hello") }
      expect(described_class.dump).to include("hello")

      described_class.configure { |config| config.debug = false }
      described_class.logdevs.pop
    end
  end

  context "JSON", :with_other_logger do
    before do
      Thread.current[:memolog_logger] = nil

      described_class.configure do |config|
        config.formatter = -> (_severity, _datetime, _progname, msg) { "#{msg}\n" }
      end
    end

    it "try to parse json on dump" do
      described_class.run do
        other_logger.log(0, JSON.dump(kek: 1))
        expect(described_class.dump(parse_json: true)).to include("kek" => 1)
      end
    end

    it "dump text if JSON.parse fails" do
      described_class.run do
        other_logger.log(0, "not_json")
        expect(described_class.dump(parse_json: true)).to include("not_json")
      end
    end

    it "return nil if dump empty" do
      described_class.run do
        expect(Memolog.dump).to eq(nil)
      end
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
      make_rails_app { described_class.init_rails_middleware! }
      expect(Rails.application.middleware[0]).to eq(Memolog::RailsMiddleware)
    end
  end

  describe "#init_sidekiq_middleware!" do
    let(:worker) { double(:worker) }
    let(:job) { double(:job) }
    let(:queue) { double(:queue) }

    it "insert middleware to Sidekiq" do
      described_class.init_sidekiq_middleware!
      expect(Memolog).to receive(:run)

      Memolog::SidekiqMiddleware.new.call(worker, job, queue)
    end
  end
end
