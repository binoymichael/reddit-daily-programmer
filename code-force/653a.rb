# http://www.codeforces.com/contest/653/problem/B

class BearBalls
  def consecutive_elements?(array)
    array.find.with_index do |_, i|
      array[i] + 2 == array[i + 2] 
    end
  end

  def run(balls)
    balls_array = balls.split.map(&:to_i).sort.uniq
    puts consecutive_elements?(balls_array) ? "YES" : "NO"
  end
end

size = gets.chomp
balls = gets.chomp
BearBalls.new.run(balls)
