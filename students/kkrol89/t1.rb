#!/usr/bin/env ruby

# Converts numbers from arabic to roman and the other way around
#
# Usage:
#    t0.rb 4
#    # prints: IV
#    t0.rb IV
#    # prints 4
#    t0.rb
#    # runs test suite

class String
  def valid_roman?
    self =~ /^M{0,}(CM|CD|D?C{0,4})(XC|XL|L?X{0,4})(IX|IV|V?I{0,4})$/
  end
  
  def valid_arabic?
    self =~ /^[0-9]+$/
  end
  
  def to_i_from_roman
    roman_values_hash = {"M" => 1000, "D" => 500, "C" => 100, "L" => 50, "X" => 10, "V" => 5, "I" => 1}
    
    previous = 0
    result = 0
    self.reverse.each_char do |symbol| 
      symbol_value = roman_values_hash[symbol]
      result += (symbol_value < previous ? -symbol_value : symbol_value) #sensitive to IV, XC, XL, etc...
      previous = symbol_value
    end
    result
  end
end

class Integer
  def to_s_roman
    arabic_values_hash = { 1000 => "M", 500 => "D", 100 => "C", 50 => "L", 10 => "X", 5 => "V", 1 => "I"}
    weight = 1
    result = ""
    self.to_s.reverse.each_char do |symbol| 
      to_add = case symbol.to_i
        when 1..3 then arabic_values_hash[weight] * symbol.to_i
        when 4 then arabic_values_hash[weight] + arabic_values_hash[weight*5]
        when 5..8 then arabic_values_hash[weight*5] + (arabic_values_hash[weight] * (symbol.to_i - 5) )
        when 9 then arabic_values_hash[weight] + arabic_values_hash[weight * 10]
        when 0 then ""
      end
      result.insert(0, to_add)
      weight *= 10
    end
    result
  end
end

class RomanNumerals
  def initialize(args)
    @number = args.first
  end
  
  def convert!
    if @number.valid_arabic?
      puts @number.to_i.to_s_roman
    elsif @number.valid_roman?
      puts @number.to_i_from_roman
    else
      puts "Invalid argument: positive integer or roman numeral expected."
    end
    exit(0) # Finish gracefully by default, change if appropriate
  end
end

# Make sure RomanNumbers#convert! ends the program with exit()
RomanNumerals.new(ARGV).convert! unless ARGV.empty?


require 'test/unit'

class StringTest < Test::Unit::TestCase
  def test_check_valid_roman
    assert "I".valid_roman?
    assert "IX".valid_roman?
    assert "VII".valid_roman?
    assert "IIII".valid_roman?
    assert "IV".valid_roman?
    assert "MCMXCIX".valid_roman?
    assert "MCCCIX".valid_roman?
    assert "MMXII".valid_roman?
  end
  
  def test_check_invalid_roman
    assert !"1234".valid_roman?
    assert !"aaaa".valid_roman?
    assert !"XXC".valid_roman?
    assert !"MCMXCIIX".valid_roman?
    assert !"IIIII".valid_roman?
  end
  
  def test_convert_valid_roman
    assert_equal 1, "I".to_i_from_roman
    assert_equal 9, "IX".to_i_from_roman
    assert_equal 7, "VII".to_i_from_roman
    assert_equal 4, "IIII".to_i_from_roman
    assert_equal 4, "IV".to_i_from_roman
    assert_equal 1999, "MCMXCIX".to_i_from_roman
    assert_equal 1309, "MCCCIX".to_i_from_roman
    assert_equal 2012, "MMXII".to_i_from_roman
  end
end

class IntegerTest < Test::Unit::TestCase
  def test_to_s_roman
    assert_equal "I", 1.to_s_roman
    assert_equal "IX", 9.to_s_roman
    assert_equal "VII", 7.to_s_roman
    assert_equal "IV", 4.to_s_roman
    assert_equal "MCMXCIX", 1999.to_s_roman
    assert_equal "MCCCIX", 1309.to_s_roman
    assert_equal "MMXII", 2012.to_s_roman
  end
end
