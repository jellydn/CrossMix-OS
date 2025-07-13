#!/bin/sh
echo "CrossMix-OS Unified Installation Script"
echo "======================================="
echo "Compatible with both TrimUI Smart Pro and TrimUI Brick"
echo ""

# Find Part1 and Part2 files using ls with wildcards
PART1_FILE=$(ls CrossMix-OS_v*_Part1.zip 2>/dev/null | head -1)
PART2_FILE=$(ls CrossMix-OS_v*_Part2.zip 2>/dev/null | head -1)

# Check if both parts are present
if [ -z "$PART1_FILE" ] || [ -z "$PART2_FILE" ]; then
  echo "Error: Both part files must be present in the same directory"
  echo "Required files:"
  echo "- CrossMix-OS_v*_Part1.zip"
  echo "- CrossMix-OS_v*_Part2.zip"
  echo ""
  echo "Found files:"
  ls -1 CrossMix-OS_v*.zip 2>/dev/null || echo "  No CrossMix-OS files found"
  exit 1
fi

echo "Found files:"
echo "  $PART1_FILE"
echo "  $PART2_FILE"
echo ""

echo "Extracting Part 1 (Core system)..."
unzip -q "$PART1_FILE"

echo "Extracting Part 2 (Heavy components)..."
unzip -q "$PART2_FILE"

echo ""
echo "Installation complete!"
echo "You can now copy the extracted files to your TrimUI device SD card."
echo ""
echo "Device Detection:"
echo "- Boot logos will automatically adapt to your device screen resolution"
echo "- All emulators and features work on both TSP and Brick devices"
echo ""
echo "Remember to backup your existing installation first!"