#!/usr/bin/env ruby

class DiffTool
  def initialize(file1, file2)
    @file1 = file1
    @file2 = file2
    @file1_lines = File.readlines(file1).map(&:chomp)
    @file2_lines = File.readlines(file2).map(&:chomp)
  end

  def find_lcs(str1, str2)
    # Create a matrix of longest common subsequence lengths
    matrix = Array.new(str1.length + 1) { Array.new(str2.length + 1, 0) }
    
    # Fill the matrix
    str1.chars.each_with_index do |char1, i|
      str2.chars.each_with_index do |char2, j|
        if char1 == char2
          matrix[i + 1][j + 1] = matrix[i][j] + 1
        else
          matrix[i + 1][j + 1] = [matrix[i + 1][j], matrix[i][j + 1]].max
        end
      end
    end
    
    # Backtrack to find the LCS
    lcs = ""
    i = str1.length
    j = str2.length
    
    while i > 0 && j > 0
      if str1[i - 1] == str2[j - 1]
        lcs = str1[i - 1] + lcs
        i -= 1
        j -= 1
      elsif matrix[i][j - 1] > matrix[i - 1][j]
        j -= 1
      else
        i -= 1
      end
    end
    
    lcs
  end

  def find_common_subsequence
    # Create a matrix of longest common subsequence lengths
    matrix = Array.new(@file1_lines.length + 1) { Array.new(@file2_lines.length + 1, 0) }
    
    # Fill the matrix
    @file1_lines.each_with_index do |line1, i|
      @file2_lines.each_with_index do |line2, j|
        if line1 == line2
          matrix[i + 1][j + 1] = matrix[i][j] + 1
        else
          matrix[i + 1][j + 1] = [matrix[i + 1][j], matrix[i][j + 1]].max
        end
      end
    end
    
    # Backtrack to find the differences
    diff = []
    i = @file1_lines.length
    j = @file2_lines.length
    
    while i > 0 || j > 0
      if i > 0 && j > 0 && @file1_lines[i - 1] == @file2_lines[j - 1]
        i -= 1
        j -= 1
      elsif j > 0 && (i == 0 || matrix[i][j - 1] >= matrix[i - 1][j])
        diff.unshift([:insert, j - 1, @file2_lines[j - 1]])
        j -= 1
      elsif i > 0 && (j == 0 || matrix[i][j - 1] < matrix[i - 1][j])
        diff.unshift([:delete, i - 1, @file1_lines[i - 1]])
        i -= 1
      end
    end
    
    diff
  end

  def format_unified_diff(changes)
    return "" if changes.empty?
    
    output = []
    changes.each do |change|
      type, _, content = change
      case type
      when :delete
        output << "< #{content}"
      when :insert
        output << "> #{content}"
      end
    end
    
    output.join("\n")
  end

  def compare
    changes = find_common_subsequence
    puts format_unified_diff(changes) unless changes.empty?
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.length != 2
    puts "Usage: #{$PROGRAM_NAME} file1 file2"
    exit 1
  end

  diff = DiffTool.new(ARGV[0], ARGV[1])
  diff.compare
end 