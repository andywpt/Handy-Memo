#!/bin/bash

[ "$#" -eq 3 ] || { echo "Usage: $0 <passphrase_path> <encrypted_files_dir> <decrypted_files_dir>"; exit 1; }

PASSPHRASE="$1"
ENCRYPTED_DIR="$2"
OUTPUT_DIR="$3"

[ -f "$PASSPHRASE" ] || { echo "Error: File '$PASSPHRASE' not found" ; exit 1 ; } 
[ -d "$ENCRYPTED_DIR" ] || { echo "Error: Folder '$ENCRYPTED_DIR' not found" ; exit 1 ; } 
[ -d "$OUTPUT_DIR" ] || { mkdir -p "$OUTPUT_DIR"; }

# Find all .gpg files in the encrypted folder
find "$ENCRYPTED_DIR" -type f -name "*.gpg" | while read -r file; do
  # Extract the filename without the .gpg extension
  decrypted_file="$OUTPUT_DIR/$(basename "${file%.gpg}")"
  # Decrypt the file using gpg
  if ! gpg --quiet --batch --yes --decrypt --passphrase="$(cat $PASSPHRASE)" \
    --output "$decrypted_file" "$file"; then
      echo "Error: Failed to decrypt $file"
  fi
done