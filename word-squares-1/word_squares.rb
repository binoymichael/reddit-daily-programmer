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
    @dictionary = load_valid_words_with_length(@grid_size)
    p @dictionary.count
    work
    puts "No result"
  end

  def work(collector = [])
    # p collector
    if collector.size == @grid_size
      puts collector.map(&:join)
      exit(true)
    end

    count = collector.size
    starting_pattern = (1..count).map do |n|
      collector[n-1][count]
    end.join

    starting_pattern = ".*" if starting_pattern.empty?
    starting_pattern_regex = Regexp.new("\\A#{starting_pattern}")

    remaining_letters_array = @input_letter_array.subtract(collector.flatten)
    @dictionary.each do |word|
      next unless word.join.match(starting_pattern_regex)
      next unless remaining_letters_array.superset?(word)
      unless work(collector << word)
        collector.pop
      end
    end
    return false
  end


  def load_valid_words_with_length(word_length)
    dictionary = []
    IO.readlines(@dictionary_path).each do |word|
      word = word.chomp.split(//)
      if word.length == word_length && @input_letter_array.superset?(word)
        dictionary << word
      end
    end
    dictionary
  end

  def all_input_combos_for(size, input)
    input.split(//).permutation(size).map do |x|
      x.join
    end
  end

  def valid_english_words(all_input_combos)
    dictionary = IO.readlines(@dictionary_path).map(&:chomp)
    (all_input_combos & dictionary).sort
  end

end

WordSquares.new(*ARGV).run

__END__
