#!/usr/bin/env bash


if [ $# -lt 1 ];then
    echo "You need to pass at least one file name; e.g. epd_202411.csv"
    exit 1
fi

if command -v rg >/dev/null 2>&1; then
    echo "ripgrep is installed...continuing"
else
    echo "ripgrep is not installed. brew install ripgrep or apt install ripgrep"
    exit 1
fi


# Check the bnf code list
if [ ! -f "bnf_codes.txt" ];then
    echo "File bnf_codes.txt does not exist. Please create it with the BNF codes you want to search for."
    exit 1
fi

BNF_CODE_LIST=$(cat bnf_codes.txt)
if [ $(echo "$BNF_CODE_LIST" | wc -l) -lt 1 ];then
    echo "bnf_codes.txt is empty. Please add BNF codes to it."
    exit 1
fi

BNF_PATTERN=$(echo "$BNF_CODE_LIST" | xargs | sed -E 's/ /|/g')


echo -e "\nDetected $(echo "$BNF_CODE_LIST" | wc -l) BNF codes in bnf_codes.txt\n"

for fname in "$@"; do
    
    echo -e "\nProcessing: $fname"


    if [ ! -f "$fname" ];then
        echo "File $fname does not exist"
        continue
    fi

    echo "Searching for BNF codes in $fname..."

    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    FILE_NAME="$(echo $fname | sed 's/.csv//g')_extracted_$TIMESTAMP.csv"
    CODES=$(rg "$BNF_PATTERN" "./$fname")
   
    if [ -z "$CODES" ]; then
        echo -e "No BNF codes found in $fname\n"
        continue
    fi

    echo "$CODES" > "$FILE_NAME"

    EXTRACTED_COUNT=$(wc -l < "$FILE_NAME")

    echo "$EXTRACTED_COUNT BNF codes extracted from $fname and saved to $FILE_NAME"


done
