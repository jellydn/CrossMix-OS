#!/bin/bash

# Test script to verify OTA canary functionality
GITHUB_REPOSITORY="jellydn/CrossMix-OS"

echo "=== Testing OTA Canary Release Detection ==="
echo ""

# Test stable channel (should get latest stable release)
echo "1. Testing STABLE channel:"
channel="stable"
if [ "$channel" = "canary" ]; then
    echo "Getting latest pre-release (canary)..."
    Release_assets_info=$(curl -s "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" | jq '.[0]')
else
    echo "Getting latest stable release..."
    Release_assets_info=$(curl -s "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/latest")
fi

if echo "$Release_assets_info" | jq -e '.message == "Not Found"' > /dev/null 2>&1; then
    echo "No releases found"
else
    tag_name=$(echo "$Release_assets_info" | jq -r '.tag_name // "none"')
    prerelease=$(echo "$Release_assets_info" | jq -r '.prerelease // false')
    echo "Found release: $tag_name (prerelease: $prerelease)"
fi

echo ""

# Test canary channel (should get latest pre-release)
echo "2. Testing CANARY channel:"
channel="canary"
if [ "$channel" = "canary" ]; then
    echo "Getting latest pre-release (canary)..."
    Release_assets_info=$(curl -s "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" | jq '.[0]')
else
    echo "Getting latest stable release..."
    Release_assets_info=$(curl -s "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/latest")
fi

if echo "$Release_assets_info" | jq -e '.message == "Not Found"' > /dev/null 2>&1; then
    echo "No releases found"
else
    tag_name=$(echo "$Release_assets_info" | jq -r '.tag_name // "none"')
    prerelease=$(echo "$Release_assets_info" | jq -r '.prerelease // false')
    echo "Found release: $tag_name (prerelease: $prerelease)"
    
    # Check if it has the expected asset
    asset=$(echo "$Release_assets_info" | jq '.assets[]? | select(.name | contains("CrossMix-OS_v"))')
    if [ -n "$asset" ]; then
        asset_name=$(echo "$asset" | jq -r '.name')
        asset_size=$(echo "$asset" | jq -r '.size')
        echo "Asset found: $asset_name (size: $asset_size bytes)"
    else
        echo "No CrossMix-OS asset found"
    fi
fi

echo ""
echo "=== OTA Test Complete ==="