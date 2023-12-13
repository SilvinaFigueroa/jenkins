
# 1 - lines beginning with “+ ” or “- ” (a plus or a minus, followed by a space)
            #REGEX='^[+-] '
    # Additional matching example:  All the log on port 63315
            #REGEX='\bport 63315\b'
    # Patter shouldn't match (egrep -v)
        #a- No match failed logs related to user Kit: 
            #NEG_REGEX= 'failed.*\bkit\b'
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


authlogFile="auth.log"
gitlogFile="git-log.txt"

declare -a patterns=(
    "^[+-] $authlogFile"
    "\\bport 63315\\b $authlogFile"
    "^commit .*\\(tag: $gitlogFile"
    "Author: Kit Transue $gitlogFile"
    "sshd.*session opened $authlogFile"
    "Failed password $authlogFile"
    "failed.*\\bkit\\b $authlogFile"
    "sshd\\[[0-9]+\\]: error: $authlogFile"
    "sshd\\[[0-9]+\\]: Invalid user $authlogFile"
    "Author:|Date: $gitlogFile"
    "commit [0-9a-z]{40} \\(.*origin/main\\) $gitlogFile"
    "^ {8} $gitlogFile"
    "sshd\\[[0-9]+\\] $authlogFile"
    "systemd-logind\\[[0-9]+\\] $authlogFile"
    "PAM( [0-9]+ more)? authentication failure $authlogFile"
)

for item in "${patterns[@]}"; do
    regex="${item% *}" 
    file="${item##* }"  

    echo "Testing pattern: $regex in file: $file"

    # Run egrep and -v and store the results to then compare if we have false positives
    mapfile -t match_results < <(egrep "$regex" "$file")
    mapfile -t non_match_results < <(egrep -v "$regex" "$file")

    # validating overlaping results
    for match in "${match_results[@]}"; do
        for non_match in "${non_match_results[@]}"; do
            if [ "$match" == "$non_match" ]; then
                echo "False positive detected: $match"
            fi
        done
    done
done    

