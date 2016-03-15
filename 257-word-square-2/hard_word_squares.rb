class HardWordSquares
  def initialize(*args)
    @row_count = (args[0] || 4).to_i
    @column_count = (args[1] || 4).to_i
    @dictionary_path  = args[2] || '/usr/share/dict/words'
  end

  def run
    @dictionary = build_dictionary_cache(@row_count, @column_count)
    work
    puts "No result"
  end

  def work(collector = [])
    p collector

    @dictionary[@column_count].each do |word|
      transposed_collector = collector.transpose
      next unless transposed_collector.all? do |combo|
        @dictionary[combo].any?
      end

      if collector.size == @row_count
        puts collector.map(&:join)
        exit(true)
      end

      unless work(collector << word)
        collector.pop
      end
    end
    return false
  end


  def build_dictionary_cache(row_count, column_count)
    dictionary = Hash.new { |h, k| h[k] = [] }
    IO.readlines(@dictionary_path).each do |word|
      word = word.chomp.split(//)
      if word.length == column_count
        dictionary[column_count] << word
      end

      if word.length == row_count
        1.upto(row_count) do |index|
          dictionary[word.slice(0, index)] << word
        end
      end
    end
    dictionary
  end

end

HardWordSquares.new(*ARGV).run

__END__

[a m e n]