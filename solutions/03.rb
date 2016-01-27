def prime?(number)
  return false if number < 2
  (2..Math.sqrt(number)).to_a.none? { |div| number % div == 0 }
end

module HelperModule
  def divide?(numerator, denominator)
    divisor = 2
    while divisor <= numerator and divisor <= denominator
      if numerator % divisor == 0 and denominator % divisor == 0
        return true
      end
      divisor += 1
    end
    false
  end
end

class RationalSequence
  include Enumerable
  include HelperModule

  attr_reader :numerator, :denominator

  def initialize(number)
    @length = number
    @numerator = 1
    @denominator = 1
    @count = 0
    @direction = false
  end

  def each
    while @count < @length
      unless divide?(@numerator, @denominator)
        yield Rational(@numerator, @denominator)
        @count += 1
      end
      if @numerator == 1 and @direction
        @denominator += 1
        @direction = ! @direction
      elsif @denominator == 1 and ! @direction
        @numerator += 1
        @direction = ! @direction
      elsif @numerator > 1 and @direction
        @numerator -= 1
        @denominator += 1
      else @denominator -= 1
        @numerator += 1
      end
    end
  end
end

class PrimeSequence
  include Enumerable

  def initialize(number)
    @length = number
  end

  def each
    count = 0
    current = 2
    while count < @length
      until prime?(current)
        current += 1
      end
      yield current
      count += 1
      current += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(number, first: 1, second: 1)
    @length = number
    @first_number = first
    @second_number = second
  end

  def each
    count = 0
    current_number = @first_number
    next_number = @second_number
    while count < @length
      count += 1
      yield current_number
      current_number, next_number = next_number, next_number + current_number
    end
  end
end

module DrunkenMathematician
  module_function
  def meaningless(n)
    rationals = RationalSequence.new(n).to_a
    group = rationals.group_by { |number| prime?(number.numerator) or prime?(number.denominator) }
    if group.size < 2
      1
    else
      group[true].reduce(:*) / group[false].reduce(:*)
    end
  end

  def aimless(n)
    primes = PrimeSequence.new(n).to_a
    rational_sum = 0

    until primes.empty?
      numerator = primes.shift
      if primes.empty?
        denominator = 1
      else
        denominator = primes.shift
      end
      rational_sum += Rational(numerator, denominator)
    end
    rational_sum
  end

  def worthless(n)
    length = 1
    if n == 0
      return []
    end
    fibonacci_number = FibonacciSequence.new(n).to_a.last
    rationals = RationalSequence.new(length).to_a
    while rationals.reduce(:+) <= fibonacci_number
      rationals = RationalSequence.new(length + 1)
      length += 1
    end
    RationalSequence.new(length - 1).to_a
  end
end
