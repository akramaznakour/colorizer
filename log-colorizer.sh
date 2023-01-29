#!/bin/bash

# Description: A command-line utility that simplifies the process of analyzing log files

# Functionality:
# - Highlights relevant information, such as framework-specific syntax
# - Allows for easy searching and filtering of log data

# Usage: ./analyze_logs.sh [OPTIONS] LOG_FILE

# Options:
# -h, --help : Show the script usage and options
# -s, --search [PATTERN] : Search for a specific pattern in the log file
# -f, --filter [LEVEL] : Filter the log file by log level (e.g. error, warning, info)

# Example:
# ./analyze_logs.sh -s "connection" -f "error" access.log

# Define script variables

# Define regular expressions for time and date formats
date_regex1='[0-9]{4}-[0-9]{2}-[0-9]{2}'
date_regex2='[0-9]{4}-[0-9]{2}-[0-9]{2}'
date_regex3='[0-9]{2}-[A-Za-z]{3}-[0-9]{4}'
time_regex1='[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}'
time_regex2='[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}'

# Define regular expressions for class paths
class_path_regex='\b([a-zA-Z]+\.[a-zA-Z]+)\b'

# Define regular expression for JSON
json_regex='\{.*\}'

# Define regular expression for brackets
brackets_regex='\[.*\]'

# Define regular expressions for log levels
error_regex='ERROR'
warning_regex='WARNING'
info_regex='INFO'
debug_regex='DEBUG'

# Define default search pattern
search_pattern=''

# Parse command line options
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    echo "Usage: ./analyze_logs.sh [OPTIONS] LOG_FILE"
    echo "Options:"
    echo "  -h, --help : Show the script usage and options"
    echo "  -s, --search [PATTERN] : Search for a specific pattern in the log file"
    echo "  -f, --filter [LEVEL] : Filter the log file by log level (e.g. error, warning, info)"
    exit 0
    ;;
    -s|--search)
    search_pattern="$2"
    shift # past argument
    shift # past value
    ;;
    -f|--filter)
    log_level="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    LOG_FILE="$1"
    shift # past argument
    ;;
esac
done

# Print log file with highlighted relevant information
if [ -f "$LOG_FILE" ]; then
    # Highlight log levels
    awk_command='{
        gsub(/'$json_regex'/,"\033[34m&\033[0m");
        gsub(/'$time_regex1'/,"\033[32m&\033[0m");
        gsub(/'$time_regex2'/,"\033[32m&\033[0m");
        gsub(/'$date_regex1'/,"\033[32m&\033[0m");
        gsub(/'$date_regex2'/,"\033[32m&\033[0m");
        gsub(/'$date_regex3'/,"\033[32m&\033[0m");
        gsub(/'class_path_regex'/,"\033[32m&\033[0m");
        gsub(/'$error_regex'/,"\033[31mERROR\033[0m");
        gsub(/'$warning_regex'/,"\033[33mWARNING\033[0m");
        gsub(/'$info_regex'/,"\033[36mINFO\033[0m");
        gsub(/'$debug_regex'/,"\033[35mDEBUG\033[0m");
        print
    }'
    if [ -z "$log_level" ]; then
        cat "$LOG_FILE" | awk "$awk_command" | grep --color=always -E "$search_pattern"
    else
        cat "$LOG_FILE" | awk "$awk_command" | grep --color=always $log_level | grep --color=always -E "$search_pattern"
    fi
else
    echo "Error: $LOG_FILE not found"
    exit 1
fi
