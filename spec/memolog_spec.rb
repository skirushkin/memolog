# frozen_string_literal: true

describe Memolog do
  it "has a version number" do
    expect(Memolog::VERSION).not_to be nil
  end

  describe "#dump", :with_other_logger do
    it "supports #info, #debug, #etc with #run" do
      Memolog.run do
        other_logger.info("it's alive")
        expect(Memolog.dump).to include Memolog.uuid
        expect(Memolog.dump).to include "it's alive"
      end

      expect(Memolog.dump).to be_nil
    end

    it "supports #log" do
      Memolog.run do
        other_logger.log(0, "it's alive")
        expect(Memolog.dump).to include Memolog.uuid
        expect(Memolog.dump).to include "it's alive"
      end
    end

    it "return nil without #run" do
      other_logger.info("it's alive")
      expect { Memolog.dump }.not_to raise_error
      expect(Memolog.dump).to be_nil
    end

    it "saves log with debug option" do
      Memolog.configure { |config| config.debug = true }
      Memolog.run { other_logger.info("it's alive") }
      expect(Memolog.dump).to include "it's alive"

      Memolog.configure { |config| config.debug = false }
      Memolog.logdevs.pop
    end
  end
end
