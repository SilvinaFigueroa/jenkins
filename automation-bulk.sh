
# Initialize counters
success_count=0
failure_count=0

# I installed jq for using this function with json files 
jq -c '.[]' regex.json | while read -r item; do 
    REGEX=$(echo "$item" | jq -r '.regex')
    INPUT_FILE=$(echo "$item" | jq -r '.input_file')
    OUTPUT_FILE=$(echo "$item" | jq -r '.output_file')
    MATCH_TYPE=$(echo "$item" | jq -r '.match_type')

#Using match_type to handle positive or negative cases 

    if [[ "$MATCH_TYPE" == "match" ]]; then
        # Handle matching case
        if egrep "$REGEX" "$INPUT_FILE" > "$OUTPUT_FILE"; then
            echo "Matched: Processed $INPUT_FILE with regex '$REGEX'. Output in $OUTPUT_FILE." > "$OUTPUT_FILE"
            success_count=$((success_count + 1))
        else
            echo "Matched: Failed to process $INPUT_FILE with regex '$REGEX'." > "$OUTPUT_FILE"
            failure_count=$((failure_count + 1))
        fi
    elif [[ "$MATCH_TYPE" == "non-match" ]]; then
        # Handle non-matching case
        if egrep -v "$REGEX" "$INPUT_FILE" > "$OUTPUT_FILE"; then
            echo "Non-matched: Processed $INPUT_FILE without regex '$REGEX'. Output in $OUTPUT_FILE." > "$OUTPUT_FILE"
            success_count=$((success_count + 1))
        else
            echo "Non-matched: Failed to process $INPUT_FILE without regex '$REGEX'." > "$OUTPUT_FILE"
            failure_count=$((failure_count + 1))
        fi
    else
        #match type validation, just in case the json object has a different one 
        echo "Error: Unknown match type '$MATCH_TYPE' for regex '$REGEX'." > "$OUTPUT_FILE"
        failure_count=$((failure_count + 1))
    fi
done

# Output success and failure counts to files
echo "Total successes: $success_count" > success.txt
echo "Total failures: $failure_count" > failure.txt
