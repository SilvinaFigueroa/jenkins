

# Shell scripting don't use spaces when assigning variables, I had an issue with this until I found the problem
# REGEX = '^[+-] '   -- > WRONG




failed=0
if [[ "$MATCH_TYPE" == "match" ]]; then

    if egrep "$REGEX" auth.log > auth-log-matching.txt
    then 
        echo "Sucess"
    else
        echo "Failed"
        failed=$((failed + 1)) # increment the counter to track failures 
    fi # end of if statement 
    echo "Failures tracking: " $failed

elif [[ "$MATCH_TYPE" == "non-match" ]]; then

    if egrep -v "$REGEX" auth.log > auth-log-matching.txt
    then 
        echo "Failed"
        failed=$((failed + 1)) # increment the counter to track failures 

    else
        echo "Sucess"
    fi # end of if statement 
    echo "Failures tracking: " $failed

exit $failed