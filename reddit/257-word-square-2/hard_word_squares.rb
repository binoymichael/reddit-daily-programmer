require 'pry'
class HardWordSquares
  def initialize(*args)
    @row_count = (args[0] || 4).to_i
    @column_count = (args[1] || 4).to_i
    @dictionary_path  = args[2] || '/usr/share/dict/words'
  end

  def run
    @col_words, @row_words = build_dictionary_cache(@row_count, @column_count)
    # p @col_words
    # p @row_words[["", 0]]
    work
    puts "No result"
  end

  def work(collector = [])
    # p collector
    if collector.size == @row_count
      puts collector.map(&:join)
      exit(true)
    end

    possible_words = []
    if collector.empty?
      possible_words = @row_words[["", 0]]
    else
      collector.transpose.each_with_index do |letter, index|
        next_letters = @col_words[letter]
        possible_row_words = []
        next_letters.each do |letter|
          possible_row_words << @row_words[[letter, index + 1]]
        end
        if index == 0
          possible_words = possible_row_words.flatten(1)
        else
          possible_words = possible_words & possible_row_words.flatten(1)
        end
      end
    end

    possible_words.each do |word|
      unless work(collector << word)
        collector.pop
      end
    end

    return false
  end


  def build_dictionary_cache(row_count, column_count)
    col_words = Hash.new { |h, k| h[k] = [] }
    row_words = Hash.new { |h, k| h[k] = [] }

    IO.readlines(@dictionary_path).each do |word|
      word = word.chomp.split(//)
      if word.length == column_count
        0.upto(column_count) do |index|
          letter = word.slice(index - 1, index).first || ""
          row_words[Array[letter, index]] << word
        end
      end

      if word.length == row_count
        0.upto(row_count) do |index|
          col_words[word.slice(0, index)] << word[index]
        end
      end
    end
    [col_words, row_words]
  end

end

HardWordSquares.new(*ARGV).run

__END__

[z o o]


