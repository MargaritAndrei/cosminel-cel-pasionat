# Cosminel cel Pasionat

## Description

This project consists of 4 tasks centered around low-level memory operations, recursion, and string manipulation using both C and Assembly.

### ✅ Task 1 – Sort

Implemented the `sort` function to sort a sequence of linked list nodes based on their `val` field using an in-place selection sort approach.  
Because the values were guaranteed to be consecutive integers starting from 1, I looped through values from `1` to `n` and at each step, searched the node with that value. Then, I linked each node to the next node in increasing order using the `next` pointer.  

### ✅ Task 2 – Operations

This task was split into two functions:

- `get_words`:  
  Used `strtok` to tokenize the input string.  
  For the first call, used `strtok(text, delimiters)`, and for the next calls, `strtok(NULL, delimiters)` until it returned `NULL`. Each word was added to the `words` vector.

- `sort`:  
  Implemented a custom comparator function that first compared by word length (`strlen`) and then lexicographically using `strcmp`.  
  Used the C `qsort` function to sort the word vector.

### ✅ Task 3 – KFib

Implemented the recursive generalized Fibonacci sequence `KFib(n, K)` with:

- `KFib(n) = 0` if `n < K`
- `KFib(n) = 1` if `n == K`
- `KFib(n) = KFib(n-1) + KFib(n-2) + ... + KFib(n-K)` otherwise

Recursive implementation carefully handles stack frames. Implemented and tested up to `n = 40`, `K = 30`.

### ✅ Task 4 – Composite Palindrome

#### Subtask 1 – Palindrome Check
Implemented a function `check_palindrome` that compares characters symmetrically from start and end of the string, up to the midpoint. Returns `1` if palindrome, otherwise `0`.

#### Subtask 2 – Composite Palindrome

Approach:
- Used bit masking to generate all `2^n - 1` ordered subsets of word indices.
- Each bitmask represented a valid subsequence.
- For each bitmask:
  - Constructed a vector of indices used to track which words to concatenate.
  - Concatenated the selected words using a helper function `concatenate_subsequence`, allocating result on heap.
  - Checked if the concatenated string is a palindrome.
  - Compared its length with the best solution found so far.
  - On tie, used lexicographical comparison.
  - Updated and freed memory accordingly.

Example helper function used in C:

```c
char* concatenate_subsequence(const char * const * const strs, int* indices, int count) {
    int total_len = 0;
    for (int i = 0; i < count; i++) {
        total_len += strlen(strs[indices[i]]);
    }
    char* result = (char*)malloc((total_len + 1) * sizeof(char));
    result[0] = '\0';
    for (int i = 0; i < count; i++) {
        strcat(result, strs[indices[i]]);
    }
    return result;
}
```

