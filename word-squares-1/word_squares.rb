class WordSquares
  def initialize(*args)
    @grid_size = (args[0] || 3).to_i
    @input = args[1] || 'onenowewe'
    @dictionary_path  = args[2] || '/usr/share/dict/words'
  end

  def run
    all_input_combos = all_input_combos_for(@grid_size, @input)
    @words_master_list = valid_english_words(all_input_combos.to_a).sort
    puts "master list ready"
    work
    puts "No result"
  end

  def work(collector = [])
    p collector
    if collector.size == @grid_size
      puts collector.map(&:join)
      exit(true)
    end

    count = collector.size
    starting_pattern = (1..count).map do |n|
      collector[n-1][count]
    end.join

    starting_pattern = ".*" if starting_pattern.empty?

    used_letters = collector.flatten
    remaining_letters = compute_remaining_letters(@input, used_letters)
    word_list = all_input_combos_for(@grid_size, remaining_letters) & @words_master_list
    possbile_words =  word_list.grep(Regexp.new("\\A#{starting_pattern}"))

    possbile_words.each do |word|
      unless work(collector << word.split(//))
        collector.pop
      end
    end
    return false
  end

  def compute_remaining_letters(input, used_letters)
    all_letters = input.split(//)
    used_letters.each do |l|
      all_letters.delete_at(all_letters.index(l))
    end
    all_letters.join
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
