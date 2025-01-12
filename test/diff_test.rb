#!/usr/bin/env ruby
require 'test/unit'
require_relative '../lib/diff'

class DiffToolTest < Test::Unit::TestCase
  def setup
    # Create temporary test files
    @file1_content = <<~TEXT
      This is line 1
      This is line 2
      This is line 3
      This is line to be deleted
      This is line 4
    TEXT

    @file2_content = <<~TEXT
      This is line 1
      This is a new line
      This is line 2
      This is line 3
      This is line 4
    TEXT

    # Write test content to temporary files
    File.write('test_file1.txt', @file1_content)
    File.write('test_file2.txt', @file2_content)
  end

  def teardown
    # Clean up temporary files
    File.delete('test_file1.txt') if File.exist?('test_file1.txt')
    File.delete('test_file2.txt') if File.exist?('test_file2.txt')
  end

  def test_string_lcs_cases
    test_cases = [
      ["ABCDEF", "ABCDEF", "ABCDEF"],
      ["ABC", "XYZ", ""],
      ["AABCXY", "XYZ", "XY"],
      ["", "", ""],
      ["ABCD", "AC", "AC"]
    ]

    test_cases.each do |str1, str2, expected|
      File.write('lcs1.txt', str1)
      File.write('lcs2.txt', str2)
      
      diff_tool = DiffTool.new('lcs1.txt', 'lcs2.txt')
      actual = diff_tool.find_lcs(str1, str2)
      
      assert_equal expected, actual, "LCS of '#{str1}' and '#{str2}' should be '#{expected}'"
    end
    
    File.delete('lcs1.txt')
    File.delete('lcs2.txt')
  end

  def test_coding_challenges_case
    file1_content = <<~TEXT
      Coding Challenges helps you become a better software engineer through that build real applications.
      I share a weekly coding challenge aimed at helping software engineers level up their skills through deliberate practice.
      I've used or am using these coding challenges as exercises to learn a new programming language or technology.
      Each challenge will have you writing a full application or tool. Most of which will be based on real world tools and utilities.
    TEXT

    file2_content = <<~TEXT
      Helping you become a better software engineer through coding challenges that build real applications.
      I share a weekly coding challenge aimed at helping software engineers level up their skills through deliberate practice.
      These are challenges that I've used or am using as exercises to learn a new programming language or technology.
      Each challenge will have you writing a full application or tool. Most of which will be based on real world tools and utilities.
    TEXT

    File.write('cc1.txt', file1_content)
    File.write('cc2.txt', file2_content)

    begin
      diff_tool = DiffTool.new('cc1.txt', 'cc2.txt')
      diff_output = diff_tool.format_unified_diff(diff_tool.find_common_subsequence)
      
      assert_match(/< Coding Challenges helps you/, diff_output)
      assert_match(/> Helping you become/, diff_output)
      assert_match(/< I've used or am using these/, diff_output)
      assert_match(/> These are challenges that/, diff_output)
    ensure
      File.delete('cc1.txt')
      File.delete('cc2.txt')
    end
  end

  def test_find_common_subsequence
    diff_tool = DiffTool.new('test_file1.txt', 'test_file2.txt')
    changes = diff_tool.find_common_subsequence

    # Test the structure of changes
    assert_kind_of Array, changes
    changes.each do |change|
      assert_kind_of Array, change
      assert_equal 3, change.length
      assert [:insert, :delete].include?(change[0])
    end

    # Test specific changes
    expected_changes = [
      [:insert, 1, "This is a new line"],
      [:delete, 3, "This is line to be deleted"]
    ]

    expected_changes.each do |expected_change|
      assert changes.any? { |change| 
        change[0] == expected_change[0] && 
        change[2] == expected_change[2]
      }, "Expected to find change: #{expected_change}"
    end
  end

  def test_format_unified_diff
    diff_tool = DiffTool.new('test_file1.txt', 'test_file2.txt')
    changes = diff_tool.find_common_subsequence
    diff_output = diff_tool.format_unified_diff(changes)

    # Test diff format
    assert_match(/^< .*/, diff_output)  # Changed from --- to <
    assert_match(/^> .*/, diff_output)  # Changed from +++ to >
    
    # Test content changes
    assert_match(/^> This is a new line/, diff_output)
    assert_match(/^< This is line to be deleted/, diff_output)
  end

  def test_empty_files
    # Create empty files
    File.write('empty1.txt', '')
    File.write('empty2.txt', '')

    begin
      diff_tool = DiffTool.new('empty1.txt', 'empty2.txt')
      changes = diff_tool.find_common_subsequence
      assert_empty changes, "Expected no changes between empty files"
    ensure
      File.delete('empty1.txt')
      File.delete('empty2.txt')
    end
  end

  def test_identical_files
    content = "This is a test\nWith multiple lines\n"
    File.write('identical1.txt', content)
    File.write('identical2.txt', content)

    begin
      diff_tool = DiffTool.new('identical1.txt', 'identical2.txt')
      changes = diff_tool.find_common_subsequence
      assert_empty changes, "Expected no changes between identical files"
    ensure
      File.delete('identical1.txt')
      File.delete('identical2.txt')
    end
  end
end 