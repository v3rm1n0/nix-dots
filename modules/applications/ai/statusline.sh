#!/usr/bin/env bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_output_tokens')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd')

TOTAL_TOKENS=$((INPUT_TOKENS + OUTPUT_TOKENS))
PERCENT_USED=$((TOTAL_TOKENS * 100 / CONTEXT_SIZE))

printf "[%s] Context: %d%% | $%.2f" "$MODEL" "$PERCENT_USED" "$COST"
