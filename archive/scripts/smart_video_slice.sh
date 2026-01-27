#!/bin/bash
# Frame Extraction Methods Comparison Script

VIDEO="$1"
if [ -z "$VIDEO" ]; then
    echo "Usage: $0 <video_file>"
    exit 1
fi

# Create output directories
mkdir -p frames_interval frames_keyframes frames_smart

# Get video duration for calculations
DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO")
DURATION_INT=$(echo "$DURATION" | cut -d. -f1)

echo "Video duration: ${DURATION_INT}s"
echo "Extracting frames using different methods..."

# Method 1: Regular intervals (every 10 seconds)
echo "1. Regular intervals (every 10s)..."
ffmpeg -i "$VIDEO" -vf "fps=1/10" -q:v 2 "frames_interval/frame_%04d.jpg" -y 2>/dev/null

# Method 2: Keyframes only
echo "2. Keyframes only..."
ffmpeg -i "$VIDEO" -vf "select='eq(pict_type,PICT_TYPE_I)'" -vsync vfr -q:v 2 "frames_keyframes/keyframe_%04d.jpg" -y 2>/dev/null

# Method 3: Smart method (keyframes + intervals)
INTERVAL=10
echo "3. Smart method (keyframes + ${INTERVAL}s intervals)..."
ffmpeg -i "$VIDEO" -vf "select='eq(pict_type,PICT_TYPE_I)+gte(t-prev_selected_t,$INTERVAL)'" -vsync vfr -q:v 2 "frames_smart/smart_%04d.jpg" -y 2>/dev/null

# Count results
INTERVAL_COUNT=$(ls frames_interval/*.jpg 2>/dev/null | wc -l)
KEYFRAME_COUNT=$(ls frames_keyframes/*.jpg 2>/dev/null | wc -l)
SMART_COUNT=$(ls frames_smart/*.jpg 2>/dev/null | wc -l)

echo
echo "Results:"
echo "--------"
echo "Interval method:  $INTERVAL_COUNT frames"
echo "Keyframe method:  $KEYFRAME_COUNT frames"
echo "Smart method:     $SMART_COUNT frames"

# Show timing analysis
echo
echo "Smart method frame timing analysis:"
echo "-----------------------------------"

# Get timestamps of smart frames
ffmpeg -i "$VIDEO" -vf "select='eq(pict_type,PICT_TYPE_I)+gte(t-prev_selected_t,$INTERVAL)',showinfo" -vsync vfr -f null - 2>&1 | \
grep "pts_time" | head -20 | \
sed 's/.*pts_time:\([0-9.]*\).*/\1/' | \
while read timestamp; do
    echo "Frame at: ${timestamp}s"
done

echo
echo "Frame extraction complete! Check the directories:"
echo "- frames_interval/ - Regular 10s intervals"
echo "- frames_keyframes/ - All I-frames (keyframes)"  
echo "- frames_smart/ - Smart combination"

# Optional: Create a comparison montage if ImageMagick is available
if command -v montage &> /dev/null; then
    echo
    echo "Creating comparison montage..."
    
    # Get first 6 frames from each method
    montage frames_interval/frame_0001.jpg frames_interval/frame_0002.jpg frames_interval/frame_0003.jpg \
            frames_keyframes/keyframe_0001.jpg frames_keyframes/keyframe_0002.jpg frames_keyframes/keyframe_0003.jpg \
            frames_smart/smart_0001.jpg frames_smart/smart_0002.jpg frames_smart/smart_0003.jpg \
            -geometry 200x150+5+5 -tile 3x3 comparison.jpg
    
    echo "Comparison montage created: comparison.jpg"
    echo "Top row: Interval method"
    echo "Middle row: Keyframe method"
    echo "Bottom row: Smart method"
fi
