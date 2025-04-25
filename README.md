# EPD Export

Manage the list of bnf_codes in `bnf_codes.txt`

## Running an export

To run an export just call the `extract_bnf_code.sh` script and pass it one or more filenames:

```bash
./extract_bnf_code.sh <filename1> <filename2> ...
```

It will generate an extracted file in the following format `<origFilename>_extracted_<timestamp>.csv`
