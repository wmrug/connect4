
class P1Player
    
  # arr = []
  
  def name
    "p1 player"
  end
  
  def inverse(colour)
    if colour == :red
      :blue
    else
      :red
    end  
  end
  
  def get_score(state, colour, a, b)
    c = inverse(colour)
    d1 = 0
    d2 = 0
    row_scores = state.each_with_index.map do |row, ri|
      ss = (0..2).map do |idx|
        r = row.drop(idx).take(4)
        if ri == a && b >= idx && b <= idx + 4
          if r.count {|x| x == c } == 3
            d1 = 4
          end
        end
        if r.include?(c)
          0
        else
          1 + r.count {|x| x == colour }
        end
      end
      ss.max
    end
    
    column_scores = 7.times.map do |i|
      col = state.map { |s| s[i] }
      ss = (0..3).map do |idx|
        r = col.drop(idx).take(4)
        if i == b && a >= idx && a <= idx + 4
          if r.count {|x| x == c } == 3
            d2 = 4
          end
        end
        
        if r.include?(c)
          0
        else
          1 + r.count {|x| x == colour }
        end
      end
      ss.max
    end
  
    
    [row_scores.max, column_scores.max, d1, d2].max
  end

  def take_turn(state, colour)
    
    possible_column_play = [0,1,2,3,4,5,6,7]
    
    scores = 7.times.map do |i|
      st = Marshal.load(Marshal.dump(state))
      col = state.map { |row| row[i] }
      idx = col.reverse.index(:none)
      if idx.nil?
        0
      else
        st[idx][i] = colour
        File.open('game.log', 'a') do |f|
          f.write("base\n")
          f.write(state.inspect + "\n")
          f.write("updated\n")
          f.write(st.inspect + "\n")
        end   
        get_score(st, colour, idx, i)
      end
    end
    
    File.open('game.log', 'a') do |f|
      f.write("#{scores.inspect}\n")
    end
    
    result = scores.index(scores.max) 
    
    File.open('game.log', 'a') do |f|
      f.write("#{result}\n")
      # f.write(state.inspect + "\n")
    end
    
    result
  end
  
  
end