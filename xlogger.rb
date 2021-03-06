require "singleton"

class XLogger
  include Singleton

  attr_accessor :stdout

  def self.switch_output(log_path = nil)
    if log_path.nil?
      STDOUT.reopen("/dev/null", "w")
    else
      STDOUT.reopen(log_path, "w")
    end

    STDERR.reopen(STDOUT)
    $stdout = STDOUT
    $stderr = STDOUT
    STDOUT.sync = true

    XLogger.instance.stdout = IO.new(IO.sysopen("/dev/tty", "a+"))
    XLogger.instance.stdout.sync = true
  end

  def self.puts(str)
    XLogger.instance.stdout.puts(str)
  end

  def self.restore_output
    STDOUT.reopen("/dev/tty")
    STDOUT.sync = true
    STDERR.reopen(STDOUT)
    STDERR.sync = true
  end
end

