
# 1 - lines beginning with “+ ” or “- ” (a plus or a minus, followed by a space)
            #REGEX='^[+-] '
    # Additional matching example:  All the log on port 63315
            #REGEX='\bport 63315\b'
    # Patter shouldn't match (egrep -v)
        #a- No match failed logs related to user Kit: 
            #NEG_REGEX= 'egrep -i failed.*\bkit\b'
        #b- Exclude Log error
            #NEG_REGEX='sshd\[[0-9]+\]: error:'
        #c- Unmatch invalid SSH login attemp
            #NEG_REGEX='sshd\[[0-9]+\]: Invalid user' 

# 2 - any lines from “git log –decorate=short” that have a tag or ref associated with them (lines 1 and 19 of included git-log.txt)
            #REGEX='^commit +.*\(+.*+tag:'
    # Additional matching example: Commits by Author: Kit Transue
            #REGEX= -B 1 'Author: Kit Transue'
    # Patter shouldn't match (egrep -v)
        #a - Match only commit and comment, excluding Author and Date 
            #NEG_REGEX= -E 'Author:|Date:
        #b - Exclude all the commits that are not pushed to origin-main
            #NEG_REGEX="commit [0-9a-z]{40} \(.*origin/main\)"
        #c - Retrieve all the file without comments
            #NEG_REGEX='^ \{8\}'


# 3 - lines representing new ssh sessions in auth.log (use “egrep -i session auth.log” to find a starting point)
            #REGEX= -i 'sshd.*session opened'
    # Additional matching example:
            #REGEX= 'Failed password'
    # Patter shouldn't match (egrep -v)
        #a - Exclude all the lines that are not sshd[number]
            #NEG_REGEX='sshd\[[0-9]+\]'
        #b - Not match any systemd-login
            #NEG_REGEX='systemd-logind\[[0-9]+\]'
        #c - Not include PAM authentication failures
            #NEG_REGEX="PAM( [0-9]+ more)? authentication failure"
 

failed=0

if egrep -v "$NEG_REGEX" auth.log > auth-log-no-matching.txt;
then 
    echo "Sucess"
else
    echo "Failed"
    failed=$((failed + 1)) # increment the counter to track failures 
fi # end of if statement 

echo "Failures tracking: " $failed

exit $failed 