# Ruby Diff Tool 🔍

A Ruby implementation of the classic Unix `diff` utility that compares files line by line and shows the differences. This tool uses the Longest Common Subsequence (LCS) algorithm to efficiently identify differences between files.

## 🌟 Features

- Line-by-line file comparison
- Efficient LCS algorithm implementation
- Clear, readable diff output format
- Handles various edge cases (empty files, identical files)
- Comprehensive test suite
- String-level LCS support

## 🚀 Installation

1. Ensure you have Ruby installed (version 2.0 or higher)
2. Clone this repository:
   ```bash
   git clone https://github.com/apih99/diffRuby.git
   cd diffRuby
   ```

## 💻 Usage

### Basic Usage

Compare two files:
```bash
ruby lib/diff.rb file1.txt file2.txt
```

### Output Format

The tool shows differences in a simple, readable format:
- Lines starting with `<` indicate lines that exist in the first file but not in the second
- Lines starting with `>` indicate lines that exist in the second file but not in the first

Example output:
```
< This line was removed
> This line was added
```

## 🧪 Testing

The project includes a comprehensive test suite using Ruby's Test::Unit framework. To run the tests:

```bash
ruby test/diff_test.rb
```

### Test Cases Include:
- String-level LCS comparisons
- Multi-line file comparisons
- Empty file handling
- Identical file handling
- Edge cases and special scenarios

## 🔧 Implementation Details

### Algorithm

The tool uses the Longest Common Subsequence (LCS) algorithm to find differences between files. The implementation includes:

1. **Matrix-based LCS calculation**
   - Time complexity: O(mn) where m and n are the lengths of the input sequences
   - Space complexity: O(mn)

2. **Backtracking for difference identification**
   - Efficiently traces back through the LCS matrix
   - Identifies insertions and deletions

### Code Structure

- `lib/diff.rb`: Main implementation file
  - `DiffTool` class with core functionality
  - Command-line interface
  - File handling

- `test/diff_test.rb`: Test suite
  - Comprehensive test cases
  - Edge case coverage
  - Integration tests

## 🎯 Key Methods

### `find_lcs(str1, str2)`
- Finds the longest common subsequence between two strings
- Used for character-level comparison

### `find_common_subsequence()`
- Identifies common subsequences in files
- Returns an array of changes (insertions and deletions)

### `format_unified_diff(changes)`
- Formats the differences in a readable output
- Handles the presentation layer of the diff

## 📝 Examples

### Comparing Text Files
```ruby
diff = DiffTool.new('original.txt', 'new.txt')
diff.compare
```

### Finding String LCS
```ruby
diff_tool = DiffTool.new('file1.txt', 'file2.txt')
lcs = diff_tool.find_lcs("ABCDEF", "ACDEF")  # Returns "ACDEF"
```

## 🔄 Performance Considerations

The implementation includes several optimizations:
- Early return for identical files
- Efficient matrix-based algorithm
- Memory-efficient string building
- Minimal file reading overhead

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by the Unix diff utility
- Based on the coding challenge from [Coding Challenges](https://codingchallenges.fyi/challenges/challenge-diff)
- Uses algorithms described in "An O(ND) Difference Algorithm and its Variations" by Eugene W. Myers

## 📚 Further Reading

- [Longest Common Subsequence Problem](https://en.wikipedia.org/wiki/Longest_common_subsequence_problem)
- [Unix diff utility](https://en.wikipedia.org/wiki/Diff)
- [Myers diff algorithm](https://en.wikipedia.org/wiki/Myers_diff_algorithm) 