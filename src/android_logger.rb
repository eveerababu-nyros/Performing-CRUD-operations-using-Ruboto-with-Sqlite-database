class AndroidLogger
  def self.debug(*args)
    # Java::android.util.Log.d *args
    puts *args
  end
    
  def self.debug?
    true
  end

  def self.info(*args)
    # Java::android.util.Log.i *args
    puts *args
  end

  def self.warn(*args)
    # Java::android.util.Log.w *args
    puts *args
  end

  def self.error(*args)
    # Java::android.util.Log.e *args
    args.each do |m|
      if m.is_a? Exception
        puts m.message
        puts m.backtrace.join("\n")
      end
      puts m
    end
  end
end
