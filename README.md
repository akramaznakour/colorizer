# log-colorizer

A command-line utility that simplifies the process of analyzing log files.

## Functionality

- Highlights relevant information such as log level, date, time, json
- Allows for easy searching and filtering of log data

## Usage

./log-colorizer.sh [OPTIONS] LOG_FILE

## Options

- -h, --help : Show the script usage and options
- -s, --search [PATTERN] : Search for a specific pattern in the log file
- -f, --filter [LEVEL] : Filter the log file by log level (e.g. error, warning, info)

## Example

./log-colorizer.sh -s "connection" -f "ERROR" access.log

## Notes

The script supports various date and time formats, as well as JSON and bracket formats.

## Contributing

Contributions and suggestions are welcome. Please submit an issue or a pull request.
