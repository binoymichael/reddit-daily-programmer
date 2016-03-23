#http://www.codeforces.com/contest/653/problem/B

class BearCompression
  def initialize(length)
    @output_length = length
    @store = Hash.new { Array.new }
  end

  def add_operation(input)
    a, b = input.split
    @store[b] += Array(a)
  end

  def run
    p solve('a')
  end

  def solve(n, count = 1)
    return n.count if count == @output_length
    nodes = Array(n)
    a = nodes.collect do |node|
      @store[node[0]].map { |n| n + node[1..-1]}
    end
    solve(a.flatten, count + 1)
  end
end

string_length, operations_count = gets.chomp.split.map(&:to_i)

b = BearCompression.new(string_length)
operations_count.times do 
  b.add_operation(gets.chomp)
end

b.run

__END__
