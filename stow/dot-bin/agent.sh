#!/bin/bash

key=$(op read "op://Personal/OpenRouter Crush API Key/credential")

OPENROUTER_API_KEY="$key" crush "$@"

