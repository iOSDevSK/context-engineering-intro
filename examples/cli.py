# Mock CLI Example

import argparse

def main():
    parser = argparse.ArgumentParser(description="Example CLI")
    parser.add_argument("--query", help="What to research", required=True)
    args = parser.parse_args()
    print(f"Researching: {args.query}")

if __name__ == "__main__":
    main()
