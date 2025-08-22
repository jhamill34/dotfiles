#!/bin/bash 
# FFmpeg Video Commands Reference
# Usage: Uncomment and modify the commands you need

# List devices
# ffmpeg -f avfoundation -list_devices true -i ""

# Capture from device
# ffmpeg \
#     -f avfoundation \
#     -r 30 \
#     -i "3" \
#     -c:v libx264 \
#     -preset fast \
#     -crf 18 \
#     -pix_fmt yuv420p \
#     -movflags \
#     +faststart \
#     output.mp4

# Turn Video into multiple images
# ffmpeg -i output.mp4 -vf "fps=1" -q:v 2 frame_%04d.jpg

# =============================================================================
# BASIC CONVERSION & COMPRESSION
# =============================================================================

# Basic format conversion
# ffmpeg -i input.mov output.mp4

# Compress video (balance quality/size)
# ffmpeg -i input.mp4 -c:v libx264 -crf 23 -c:a aac output.mp4

# High compression (smaller files)
# ffmpeg -i input.mp4 -c:v libx264 -crf 28 -preset slow output.mp4

# Quick conversion (faster, larger files)
# ffmpeg -i input.mp4 -c:v libx264 -crf 18 -preset ultrafast output.mp4

# Convert with specific bitrate
# ffmpeg -i input.mp4 -b:v 1M -c:a aac output.mp4


# =============================================================================
# TRIMMING & CUTTING
# =============================================================================

# Cut from 30s to 2min 30s
# ffmpeg -ss 00:00:30 -to 00:02:30 -i input.mp4 -c copy output.mp4

# Cut first 10 seconds
# ffmpeg -ss 00:00:10 -i input.mp4 -c copy output.mp4

# Cut specific duration (60 seconds starting from 30s)
# ffmpeg -ss 00:00:30 -t 00:01:00 -i input.mp4 -c copy output.mp4

# Remove last 10 seconds
# ffmpeg -i input.mp4 -t $(echo "$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.mp4) - 10" | bc) -c copy output.mp4


# =============================================================================
# RESIZING & SCALING
# =============================================================================

# Resize to 1080p (maintain aspect ratio)
# ffmpeg -i input.mp4 -vf scale=-1:1080 output.mp4

# Resize to specific dimensions
# ffmpeg -i input.mp4 -vf scale=1280:720 output.mp4

# Scale by percentage (50% size)
# ffmpeg -i input.mp4 -vf scale=iw*0.5:ih*0.5 output.mp4

# Resize with padding to exact dimensions
# ffmpeg -i input.mp4 -vf scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2 output.mp4


# =============================================================================
# AUDIO OPERATIONS
# =============================================================================

# Extract audio only
# ffmpeg -i input.mp4 -vn -acodec copy audio.aac

# Remove audio from video
# ffmpeg -i input.mp4 -c copy -an output.mp4

# Add audio to video
# ffmpeg -i video.mp4 -i audio.mp3 -c:v copy -c:a aac output.mp4

# Replace audio in video
# ffmpeg -i video.mp4 -i audio.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 output.mp4

# Adjust audio volume (200% = double)
# ffmpeg -i input.mp4 -filter:a "volume=2.0" output.mp4

# Normalize audio
# ffmpeg -i input.mp4 -filter:a loudnorm output.mp4


# =============================================================================
# FRAME OPERATIONS
# =============================================================================

# Extract single frame at 5 seconds
# ffmpeg -ss 00:00:05 -i input.mp4 -vframes 1 frame.png

# Extract frames every 5 seconds
# ffmpeg -i input.mp4 -vf fps=1/5 frame_%04d.png

# Extract every Nth frame (every 150th frame)
# ffmpeg -i input.mp4 -vf "select=not(mod(n\,150))" -vsync vfr frame_%04d.png

# Create video from images
# ffmpeg -r 30 -i frame_%04d.png -c:v libx264 -pix_fmt yuv420p output.mp4

# Create video from images with specific duration per image
# ffmpeg -r 1/3 -i frame_%04d.png -c:v libx264 -r 30 -pix_fmt yuv420p output.mp4


# =============================================================================
# CONCATENATION
# =============================================================================

# Simple concat (same format/codec) - create list file first
# echo "file 'video1.mp4'" > list.txt
# echo "file 'video2.mp4'" >> list.txt
# ffmpeg -f concat -safe 0 -i list.txt -c copy output.mp4

# Concat different formats (re-encode)
# ffmpeg -i video1.mp4 -i video2.mov -filter_complex "[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1" output.mp4

# Quick concat for same format files
# ffmpeg -i "concat:video1.mp4|video2.mp4" -c copy output.mp4


# =============================================================================
# SCREEN RECORDING
# =============================================================================

# macOS screen recording
# ffmpeg -f avfoundation -r 30 -i "1" -c:v libx264 -crf 18 -pix_fmt yuv420p -movflags +faststart output.mp4

# macOS with audio
# ffmpeg -f avfoundation -r 30 -i "1:0" -c:v libx264 -crf 18 -c:a aac -b:a 128k output.mp4

# Linux screen recording
# ffmpeg -f x11grab -s 1920x1080 -r 30 -i :0.0 -c:v libx264 -crf 18 output.mp4

# Windows screen recording
# ffmpeg -f gdigrab -s 1920x1080 -r 30 -i desktop -c:v libx264 -crf 18 output.mp4

# List available devices (macOS)
# ffmpeg -f avfoundation -list_devices true -i ""


# =============================================================================
# SPEED & TIME EFFECTS
# =============================================================================

# 2x speed (video and audio)
# ffmpeg -i input.mp4 -filter:v "setpts=0.5*PTS" -filter:a "atempo=2.0" output.mp4

# 0.5x speed (slow motion)
# ffmpeg -i input.mp4 -filter:v "setpts=2.0*PTS" -filter:a "atempo=0.5" output.mp4

# 4x speed (video only, remove audio)
# ffmpeg -i input.mp4 -filter:v "setpts=0.25*PTS" -an output.mp4

# Reverse video
# ffmpeg -i input.mp4 -vf reverse -af areverse output.mp4


# =============================================================================
# GIF CREATION
# =============================================================================

# Create GIF with palette for better quality
# ffmpeg -i input.mp4 -vf "fps=10,scale=320:-1:flags=lanczos,palettegen" palette.png
# ffmpeg -i input.mp4 -i palette.png -filter_complex "fps=10,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" output.gif

# Simple GIF creation
# ffmpeg -i input.mp4 -vf "fps=10,scale=320:-1" output.gif

# GIF from specific time range
# ffmpeg -ss 00:00:10 -t 00:00:05 -i input.mp4 -vf "fps=10,scale=320:-1:flags=lanczos,palettegen" palette.png
# ffmpeg -ss 00:00:10 -t 00:00:05 -i input.mp4 -i palette.png -filter_complex "fps=10,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" output.gif


# =============================================================================
# VIDEO INFO & ANALYSIS
# =============================================================================

# Get complete video info (JSON format)
# ffprobe -v quiet -print_format json -show_format -show_streams input.mp4

# Get duration only
# ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.mp4

# Get video dimensions
# ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 input.mp4

# Get frame rate
# ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 input.mp4

# Get bitrate
# ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 input.mp4

# Get codec info
# ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 input.mp4


# =============================================================================
# FILTERS & EFFECTS
# =============================================================================

# Add watermark
# ffmpeg -i input.mp4 -i watermark.png -filter_complex overlay=10:10 output.mp4

# Fade in/out effects
# ffmpeg -i input.mp4 -vf "fade=in:0:30,fade=out:st=270:d=30" output.mp4

# Stabilize shaky video
# ffmpeg -i input.mp4 -vf vidstabdetect=shakiness=10:accuracy=15 -f null -
# ffmpeg -i input.mp4 -vf vidstabtransform=smoothing=30:interpol=bilinear output.mp4

# Add subtitle file
# ffmpeg -i input.mp4 -i subtitles.srt -c copy -c:s mov_text output.mp4

# Burn subtitles into video
# ffmpeg -i input.mp4 -vf subtitles=subtitles.srt output.mp4


# =============================================================================
# QUALITY & FORMAT SETTINGS
# =============================================================================

# High quality H.264
# ffmpeg -i input.mp4 -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k output.mp4

# H.265 (HEVC) encoding
# ffmpeg -i input.mp4 -c:v libx265 -preset medium -crf 23 -c:a aac output.mp4

# WebM format
# ffmpeg -i input.mp4 -c:v libvpx-vp9 -crf 30 -b:v 0 -c:a libopus output.webm

# MP3 audio extraction
# ffmpeg -i input.mp4 -q:a 0 -map a output.mp3


# =============================================================================
# BATCH OPERATIONS
# =============================================================================

# Batch convert all MOV files to MP4
# for i in *.mov; do ffmpeg -i "$i" -c:v libx264 -crf 23 -c:a aac "${i%.*}.mp4"; done

# Batch compress all MP4 files
# for i in *.mp4; do ffmpeg -i "$i" -c:v libx264 -crf 28 -c:a aac "compressed_$i"; done

# Batch extract audio from all videos
# for i in *.mp4; do ffmpeg -i "$i" -vn -acodec copy "${i%.*}.aac"; done


# =============================================================================
# ADVANCED OPERATIONS
# =============================================================================

# Picture-in-picture
# ffmpeg -i main.mp4 -i overlay.mp4 -filter_complex "[1:v]scale=320:240[pip];[0:v][pip]overlay=10:10" output.mp4

# Side-by-side videos
# ffmpeg -i left.mp4 -i right.mp4 -filter_complex hstack output.mp4

# Create thumbnail contact sheet
# ffmpeg -i input.mp4 -vf "fps=1/60,scale=160:120,tile=6x4" contact_sheet.png

# Loop video N times
# ffmpeg -stream_loop 3 -i input.mp4 -c copy output.mp4


# =============================================================================
# NOTES
# =============================================================================
# CRF values: 0 = lossless, 18 = visually lossless, 23 = good quality, 28 = acceptable quality
# Presets: ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# -c copy = stream copy (no re-encoding, fastest)
# -pix_fmt yuv420p = ensures compatibility with most players
