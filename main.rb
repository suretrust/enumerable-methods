# recreating some methods in Enumerable module
module Enumerable
  def my_each
    if is_a? Array
      (0..length - 1).each do |i|
        yield self[i]
      end
    elsif is_a? Hash
      keys.each do |k|
        yield k, self[k]
      end
    end
  end

  def my_each_with_index
    if is_a? Array
      (0..length - 1).each do |i|
        yield(self[i], i)
      end
    elsif is_a? Hash
      (0..keys.length - 1).each do |k|
        yield([keys[k], values[k]], k)
      end
    end
  end

  def my_select
    if is_a? Array
      result = []
      my_each { |item| result.push(item) if yield(item) }
      result
    elsif is_a? Hash
      result = Hash.new(0)
      my_each { |k, v| result[k] = v if yield(k, v) }
      result
    end
  end

  def my_all_block(result, &block)
    if is_a? Array
      my_each do |item|
        result = false unless yield(item)
      end
    elsif is_a? Hash
      my_each do |k, v|
        result = false unless yield(k, v)
      end
    end
    result    
  end

  def my_all_not_block(result, a)
    
      if a.is_a? Class
        result = my_all_arg_class(result, a)
      else
        result = my_all_arg_class_else(result, a)
      end
    
    result
  end

  def my_all_empty_arg(result)
    if is_a? Array
      my_each { |item| result = false unless item }
    elsif is_a? Hash
      my_each { |k, v| result = false unless v[k] }
    end
    result
  end

  def my_all_arg_class(result, a)
    if is_a? Array
      my_each do |item|
        result = false unless item.is_a? a
      end
    elsif is_a? Hash
      my_each do |k, v|
        result = false unless v[k].is_a? a
      end
    end
    result
  end

  def my_all_arg_class_else(result, a)
    if is_a? Array
      my_each do |item|
        result = false unless item == a
      end
    elsif is_a? Hash
      my_each do |k, v|
        result = false unless v[k] == a
      end
    end
    result    
  end

  def my_all?(*arg, &block)
    result = true
    if block_given?
      result = my_all_block(result, &block)
    elsif arg.empty?
      result = my_all_empty_arg(result)
    else
      arg.my_each { |a| result = my_all_not_block(result, a) }
    end
    result
  end

  def my_any?(*arg)
    result = false
    if block_given?
      if is_a? Array
        my_each do |item|
          result = true if yield(item)
        end
      elsif is_a? Hash
        my_each do |k, v|
          result = true if yield(k, v)
        end
      end
    elsif arg.empty?
      if is_a? Array
        my_each do |item|
          result = true if item
        end
      elsif is_a? Hash
        my_each do |k, v|
          result = true if v[k]
        end
      end
    else
      arg.my_each do |a|
        if is_a? Array
          my_each do |item|
            result = true if item == a
          end
        elsif is_a? Hash
          my_each do |k, v|
            result = true if v[k] == a
          end
        end
      end
    end
    result
  end

  def my_none?(*arg)
    result = true

    if block_given?
      if is_a? Array
        my_each do |item|
          if yield item
            result = false
            break
          end
        end
      elsif is_a? Hash
        my_each do |k, v|
          if yield(k, v)
            result = false
            break
          end
        end
      end
    elsif arg.empty?
      if is_a? Array
        my_each do |item|
          if item
            result = false
            break
          end
        end
      elsif is_a? Hash
        my_each do |k, v|
          if v[k]
            result = false
            break
          end
        end
      end
    else
      arg.my_each do |a|
        if is_a? Array
          my_each do |item|
            if item == a
              result = false
              break
            end
          end
        elsif is_a? Hash
          my_each do |k, v|
            if v[k] == a
              result = false
              break
            end
          end
        end
      end
    end
    result
  end

  def my_count(arg = nil)
    count = 0
    if block_given?
      if is_a? Array
        my_each do |item|
          count += 1 if yield(item)
        end
      elsif is_a? Hash
        my_each do |k, v|
          count += 1 if yield(k, v)
        end
      end

    else
      if arg.nil?
        return length
      else
        if is_a? Array
          my_each do |item|
            count += 1 if item == arg
          end
        elsif is_a? Hash
          my_each do |_k, v|
            count += 1 if v == arg
          end
        end
      end
    end
    count
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    result = []
    if is_a? Range
      arr = to_a
      arr.my_each do |item|
        result.push(yield(item))
      end
    elsif is_a? Array
      my_each do |item|
        result.push(yield(item))
      end
    elsif is_a? Hash
      my_each do |k, v|
        result.push(yield(k, v))
      end
    end
    result
  end
end

puts %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
puts %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
puts %w[ant bear cat].my_all?(/t/)                        #=> false
puts [1, 2i, 3.14].my_all?(Numeric)                       #=> true
puts [nil, true, 99].my_all?                              #=> false
puts [].my_all?                                           #=> true

# puts 2i.is_a? Numeric

# puts Numeric.class
