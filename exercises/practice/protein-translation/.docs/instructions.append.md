# Instructions append

## Reserved Memory

Bytes 1024-1279 of the linear memory are reserved for the input string.

The input string can be modified in place if desired.

## Input format

The codons are delivered concatenated without padding as a string.

## Output format

Output the protein sequence as a null-terminated string, with a newline character after every protein.

An example output would be `"Methionine\nPhenylalanine\nSerine\n"`

If the input is invalid, output an empty string.
