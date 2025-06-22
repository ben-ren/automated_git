#!/bin/bash

# Helper: prints Usage
print_usage(){
    echo "Usage:"
    echo "  $0 new <remote_url> <branch> <commit_message>"
    echo "  $0 update <branch> <commit_message>"
    echo 
    echo "Examples: "
    echo "  $0 new https://github.com/user/repo.git main \"Initial commit\""
    echo "  $0 update main \"Fixed login bug\""
    exit 1
}

# Ensure at least 1 argument is passed
if [ $# -lt 1 ]; then
    echo "Error: Mode not specified (use 'new' or 'update')"
    print_usage
fi

mode=$1

# Warn if gitignore doesn't exist
if [ ! -f .gitignore ]; then
    echo "Warning: There is no .gitignore file found. Please add to avoid committing unwanted files."
    read -p "Do you want to continue anyway? (y/n): " answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo "Aborting script"
        exit 1
    fi
fi

#===== NEW MODE (first-time project push) =====
if [ "$mode" = "new" ]; then
    if [ $# -ne 4 ]; then
        echo "Error: (New Project Mode) requires 3 arguments"
        print_usage
    fi

    remote_url=$2
    branch=$3
    message=$4

    echo "Initialising Git Repo..."
    git init || exit 1

    echo "Staging Files..."
    git add . || exit 1

    echo "Creating commit..."
    git commit -m "$message" || exit 1

    echo "Adding remote origin..."
    git remote add origin "$remote_url" || exit 1
    git remote -v

    echo "Pushing to $branch"
    git push -u origin "$branch" || exit 1

    echo "Complete: Project pushed to new remote repository"

#===== UPDATE MODE (updating existing repo) =====
elif [ "$mode" = "update" ]; then
    if [ $# -ne 3 ]; then
        echo "Error: (Update Mode) requires 2 arguments"
        print_usage
    fi

    branch=$2
    message=$3

    echo "Staging Files..."
    git add . || exit 1

    echo "Creating commit..."
    git commit -m "$message" || exit 1

    echo "Pushing to $branch"
    git push -u origin "$branch" || exit 1

    echo "Complete: Changes pushed to repository"

#===== INVALID MODE =====
else
    echo "Error: Invalid Mode '$mode'. Use 'new' or 'update'."
    print_usage
fi