require 'Shellwords'

module TestHelper

  class PipeHelper
    def initialize(command)
      @pipe = IO.popen(Shellwords.escape(command), "w+")
    end

    def write(write)
      @pipe.write(write)
    end

    def close
      @pipe.close_write
      puts @pipe.read
      @pipe.close
    end
  end
end    