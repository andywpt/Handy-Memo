#!/bin/sh

print_table() {
    local title="$1"
    local -a headers=("${!2}")
    local -a rows=("${!3}")

    # Calculate the maximum lengths of each column
    local column_lengths=()
    for i in ${!headers[@]}; do
        column_lengths[i]=${#headers[i]}
    done

    # Iterate through the rows to calculate maximum lengths
    for row in "${rows[@]}"; do
        IFS=$'\t' read -r -a columns <<< "$row"
        for ((i = 0; i < ${#columns[@]}; i++)); do
            column_lengths[i]=$((${#columns[i]} > column_lengths[i] ? ${#columns[i]} : column_lengths[i]))
        done
    done

    # Calculate total width considering padding and dividers
    local total_width=0
    for length in "${column_lengths[@]}"; do
        total_width=$((total_width + length + 2)) # Add 2 for padding (1 space on each side)
    done
    total_width=$((total_width + ${#headers[@]} - 1)) # Add dividers for columns + borders

    # Print top border
    printf "+%s+\n" "$(printf "%-${total_width}s" "" | tr ' ' '-')"

    # Print the title in green, centered
    local padding=$((total_width - ${#title} - 4)) # 2 for leading and trailing spaces
    printf "| %*s %s %*s |\n" $((padding / 2)) "" "$title" $((padding - padding / 2)) ""

    # # Print separator after the title
    # printf "+%s+\n" "$(printf "%-${total_width}s" "" | tr ' ' '-')"

    # # Print header with adjusted widths
    # for ((i = 0; i < ${#headers[@]}; i++)); do
    #     printf "| %-${column_lengths[i]}s " "${headers[i]}"
    # done
    # printf "|\n"
    
    # Print separator after the header
    printf "+%s+\n" "$(printf "%-${total_width}s" "" | sed 's/ /-/g')"

    # Print each row with adjusted column widths
    for row in "${rows[@]}"; do
        IFS=$'\t' read -r -a columns <<< "$row"
        for ((i = 0; i < ${#columns[@]}; i++)); do
            printf "| %-${column_lengths[i]}s " "${columns[i]}"
        done
        printf "|\n"
    done

    printf "+%s+\n\n" "$(printf "%-${total_width}s" "" | sed 's/ /-/g')"
}