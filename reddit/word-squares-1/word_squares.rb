class Array
  def subtract(small)
    large_dup = self.dup
    small.each do |l|
      large_dup.delete_at(large_dup.index(l)) if large_dup.include?(l)
    end
    large_dup
  end

  def superset?(small)
    large_dup = self.dup
    small.each do |l|
      if large_dup.include?(l)
        large_dup.delete_at(large_dup.index(l)) 
      else
        return false
      end
    end
    !!large_dup
  end
end

class WordSquares
  def initialize(*args)
    @grid_size = (args[0] || 3).to_i
    @input = args[1] || 'onenowewe'
    @dictionary_path  = args[2] || '/usr/share/dict/words'
    @input_letter_array = @input.split(//)
  end

  def run
    @dictionary = build_dictionary_cache(@grid_size)
    work
    puts "No result"
  end

  def work(collector = [])
    if collector.size == @grid_size
      puts collector.map(&:join)
      exit(true)
    end

    count = collector.size
    starting_pattern = (1..count).map do |n|
      collector[n-1][count]
    end

    remaining_letters_array = @input_letter_array.subtract(collector.flatten)
    @dictionary[starting_pattern].each do |word|
      next unless remaining_letters_array.superset?(word)
      unless work(collector << word)
        collector.pop
      end
    end
    return false
  end


  def build_dictionary_cache(word_length)
    dictionary = Hash.new { |h, k| h[k] = [] }
    IO.readlines(@dictionary_path).each do |word|
      word = word.chomp.split(//)
      if word.length == word_length && @input_letter_array.superset?(word)
        0.upto(word_length - 1) do |index|
          dictionary[word.slice(0, index)] << word
        end
      end
    end
    dictionary
  end

end

WordSquares.new(*ARGV).run

__END__
