# dotenv-to-json

A simple CLI tool to convert `.env` files to JSON format.

## Installation

Install using [`uv` package manager](https://docs.astral.sh/uv/getting-started/installation/):

```bash
make install
```

Or install directly:

```bash
uv tool install .
```

## Usage

### Basic Usage

Convert a `.env` file to JSON:

```bash
env2json -i .env
```

### Read from stdin

```bash
cat .env | env2json
```

or

```bash
env2json -i -
```

### Write to a file

```bash
env2json -i .env -o output.json
```

### Pretty-print JSON

```bash
env2json -i .env -p
```

### Command-line Options

- `-i, --input`: Input `.env` file path (default: stdin, use `-` for explicit stdin)
- `-o, --output`: Output JSON file path (default: stdout)
- `-p, --pretty`: Pretty-print JSON with indentation

## Features

- Supports standard `.env` file format
- Handles optional `export` keyword (e.g., `export KEY=value`)
- Supports quoted values (single or double quotes)
- Strips comments (lines starting with `#` or `;`)
- Removes inline comments (after `#` or `;`)
- Handles escaped characters in quoted values
- Reads from stdin or file
- Outputs to stdout or file

## Example

Input `.env` file:

```env
# Database configuration
DB_HOST=localhost
DB_PORT=5432
export DB_NAME=mydb
DB_PASSWORD="secret123"
API_KEY='key-with-#-symbol'
COMMENT_VALUE=value # inline comment
```

Output JSON:

```json
{"DB_HOST":"localhost","DB_PORT":"5432","DB_NAME":"mydb","DB_PASSWORD":"secret123","API_KEY":"key-with-#-symbol","COMMENT_VALUE":"value"}
```

With `-p` flag:

```json
{
  "DB_HOST": "localhost",
  "DB_PORT": "5432",
  "DB_NAME": "mydb",
  "DB_PASSWORD": "secret123",
  "API_KEY": "key-with-#-symbol",
  "COMMENT_VALUE": "value"
}
```

## Requirements

- Python >= 3.8

## Development

### Running During Development

You don't need to reinstall after every code change. You have several options:

**Option 1: Run directly (recommended for development)**
```bash
python -m dotenv_to_json.cli -i .env
```

or

```bash
python main.py -i .env
```

**Option 2: Install in editable mode (changes reflect automatically)**
```bash
uv pip install -e .
```

or

```bash
pip install -e .
```

After installing in editable mode, you can use `env2json` command and changes will be reflected automatically.

**Option 3: Use `uv tool install` (requires reinstall after changes)**
```bash
uv tool install .
```

This installs globally but requires reinstallation after code changes.

### Testing

Run tests:

```bash
make test
```

Run the CLI:

```bash
make run
```

