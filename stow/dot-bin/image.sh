#!/bin/bash
# FFmpeg Image Commands Reference
# Usage: Uncomment and modify the commands you need

# =============================================================================
# BASIC IMAGE OPERATIONS
# =============================================================================

# Convert formats
# ffmpeg -i input.jpg output.png
# ffmpeg -i input.png output.webp
# ffmpeg -i input.bmp output.jpg

# Resize image (maintain aspect ratio)
# ffmpeg -i input.jpg -vf scale=800:-1 output.jpg
# ffmpeg -i input.jpg -vf scale=-1:600 output.jpg

# Resize to specific dimensions
# ffmpeg -i input.jpg -vf scale=800:600 output.jpg

# Resize by percentage
# ffmpeg -i input.jpg -vf scale=iw*0.5:ih*0.5 output.jpg  # 50% size
# ffmpeg -i input.jpg -vf scale=iw*2:ih*2 output.jpg      # 200% size


# =============================================================================
# IMAGE QUALITY & COMPRESSION
# =============================================================================

# High quality JPEG (q:v range: 1-31, lower = better quality)
# ffmpeg -i input.png -q:v 2 output.jpg

# Compress JPEG (higher number = more compression)
# ffmpeg -i input.jpg -q:v 10 compressed.jpg
# ffmpeg -i input.jpg -q:v 20 highly_compressed.jpg

# Convert to WebP with quality setting
# ffmpeg -i input.jpg -c:v libwebp -quality 80 output.webp
# ffmpeg -i input.jpg -c:v libwebp -lossless 1 output.webp  # lossless WebP

# PNG with compression level (0-9, higher = more compression)
# ffmpeg -i input.jpg -compression_level 9 output.png


# =============================================================================
# CROPPING & PADDING
# =============================================================================

# Crop image (width:height:x_offset:y_offset)
# ffmpeg -i input.jpg -vf crop=400:300:100:50 cropped.jpg

# Crop from center
# ffmpeg -i input.jpg -vf crop=800:600 centered_crop.jpg

# Crop square from center
# ffmpeg -i input.jpg -vf crop=min(iw\,ih):min(iw\,ih) square_crop.jpg

# Smart crop (remove borders)
# ffmpeg -i input.jpg -vf cropdetect=24:16:0 -f null -  # detect crop parameters first
# ffmpeg -i input.jpg -vf crop=1920:800:0:140 cropped.jpg  # use detected parameters

# Add padding/borders (width:height:x:y:color)
# ffmpeg -i input.jpg -vf pad=1000:800:100:100:black padded.jpg
# ffmpeg -i input.jpg -vf pad=1000:800:100:100:white padded.jpg
# ffmpeg -i input.jpg -vf pad=1000:800:100:100:#FF0000 padded.jpg  # red padding

# Center image with padding
# ffmpeg -i input.jpg -vf pad=1000:800:(ow-iw)/2:(oh-ih)/2:black centered.jpg


# =============================================================================
# ROTATION & FLIPPING
# =============================================================================

# Rotate 90 degrees clockwise
# ffmpeg -i input.jpg -vf transpose=1 rotated_90cw.jpg

# Rotate 90 degrees counter-clockwise
# ffmpeg -i input.jpg -vf transpose=2 rotated_90ccw.jpg

# Rotate 180 degrees
# ffmpeg -i input.jpg -vf transpose=2,transpose=2 rotated_180.jpg

# Flip horizontally (mirror)
# ffmpeg -i input.jpg -vf hflip flipped_h.jpg

# Flip vertically
# ffmpeg -i input.jpg -vf vflip flipped_v.jpg

# Rotate by arbitrary angle (degrees)
# ffmpeg -i input.jpg -vf rotate=45*PI/180 rotated_45.jpg
# ffmpeg -i input.jpg -vf rotate=30*PI/180:fillcolor=white rotated_30.jpg


# =============================================================================
# IMAGE FILTERS & EFFECTS
# =============================================================================

# Blur image
# ffmpeg -i input.jpg -vf boxblur=5:1 blurred.jpg
# ffmpeg -i input.jpg -vf gblur=sigma=3 gaussian_blur.jpg

# Sharpen image
# ffmpeg -i input.jpg -vf unsharp=5:5:1.0:5:5:0.0 sharpened.jpg

# Adjust brightness (0.0 = black, 1.0 = normal, 2.0 = double brightness)
# ffmpeg -i input.jpg -vf eq=brightness=0.2 brighter.jpg
# ffmpeg -i input.jpg -vf eq=brightness=-0.2 darker.jpg

# Adjust contrast (1.0 = normal, 1.5 = 50% more contrast)
# ffmpeg -i input.jpg -vf eq=contrast=1.5 contrast.jpg
# ffmpeg -i input.jpg -vf eq=contrast=0.5 low_contrast.jpg

# Adjust saturation (1.0 = normal, 0.0 = grayscale, 2.0 = double saturation)
# ffmpeg -i input.jpg -vf eq=saturation=1.5 saturated.jpg
# ffmpeg -i input.jpg -vf eq=saturation=0 desaturated.jpg

# Convert to grayscale
# ffmpeg -i input.jpg -vf format=gray grayscale.jpg
# ffmpeg -i input.jpg -vf hue=s=0 grayscale2.jpg

# Add noise
# ffmpeg -i input.jpg -vf noise=alls=20:allf=t+u noisy.jpg

# Sepia effect
# ffmpeg -i input.jpg -vf colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131 sepia.jpg

# Vintage/old photo effect
# ffmpeg -i input.jpg -vf eq=contrast=1.2:brightness=0.1:saturation=0.8,noise=alls=10 vintage.jpg


# =============================================================================
# COLOR OPERATIONS
# =============================================================================

# Adjust gamma
# ffmpeg -i input.jpg -vf eq=gamma=1.5 gamma_adjusted.jpg

# Color temperature adjustment (warmer/cooler)
# ffmpeg -i input.jpg -vf colortemperature=6500 color_temp.jpg

# Hue adjustment
# ffmpeg -i input.jpg -vf hue=h=90 hue_shifted.jpg

# Invert colors
# ffmpeg -i input.jpg -vf negate inverted.jpg

# Posterize (reduce colors)
# ffmpeg -i input.jpg -vf palettegen=max_colors=8:stats_mode=single[pal];[0:v][pal]paletteuse posterized.jpg


# =============================================================================
# TEXT & OVERLAYS
# =============================================================================

# Add text overlay (adjust font path for your system)
# ffmpeg -i input.jpg -vf drawtext="fontfile=/System/Library/Fonts/Arial.ttf:text='Hello World':fontsize=24:fontcolor=white:x=10:y=10" text_overlay.jpg

# Add text with background
# ffmpeg -i input.jpg -vf drawtext="fontfile=/System/Library/Fonts/Arial.ttf:text='Hello':fontsize=30:fontcolor=white:x=10:y=10:box=1:boxcolor=black@0.5" text_bg.jpg

# Add timestamp
# ffmpeg -i input.jpg -vf drawtext="fontfile=/System/Library/Fonts/Arial.ttf:text='%{localtime\:%Y-%m-%d %H\:%M\:%S}':fontsize=20:fontcolor=white:x=10:y=10" timestamp.jpg

# Add copyright watermark
# ffmpeg -i input.jpg -vf drawtext="fontfile=/System/Library/Fonts/Arial.ttf:text='© 2025':fontsize=16:fontcolor=white@0.7:x=w-tw-10:y=h-th-10" watermarked.jpg

# Overlay another image
# ffmpeg -i background.jpg -i overlay.png -filter_complex overlay=10:10 combined.jpg
# ffmpeg -i background.jpg -i overlay.png -filter_complex overlay=main_w-overlay_w-10:10 overlay_right.jpg


# =============================================================================
# COMBINING MULTIPLE IMAGES
# =============================================================================

# Side-by-side comparison (horizontal)
# ffmpeg -i image1.jpg -i image2.jpg -filter_complex hstack comparison_h.jpg

# Stack vertically
# ffmpeg -i image1.jpg -i image2.jpg -filter_complex vstack stacked_v.jpg

# 2x2 grid
# ffmpeg -i img1.jpg -i img2.jpg -i img3.jpg -i img4.jpg -filter_complex "[0:v][1:v]hstack[top];[2:v][3:v]hstack[bottom];[top][bottom]vstack" grid_2x2.jpg

# Create panorama (horizontal concatenation)
# ffmpeg -i left.jpg -i right.jpg -filter_complex hstack panorama.jpg

# Blend two images
# ffmpeg -i image1.jpg -i image2.jpg -filter_complex blend=all_mode=overlay:all_opacity=0.5 blended.jpg


# =============================================================================
# EXTRACTING FROM VIDEOS
# =============================================================================

# Extract single frame from video
# ffmpeg -i video.mp4 -ss 00:00:10 -vframes 1 -q:v 2 frame.jpg

# Create thumbnail from video
# ffmpeg -i video.mp4 -ss 00:00:10 -vframes 1 -vf scale=400:-1 -q:v 2 thumbnail.jpg

# Create contact sheet/grid of frames from video
# ffmpeg -i video.mp4 -vf "fps=1/10,scale=320:240,tile=4x3" contact_sheet.jpg

# Extract all frames from video
# ffmpeg -i video.mp4 -vf fps=30 frame_%04d.jpg


# =============================================================================
# CREATING VIDEOS FROM IMAGES
# =============================================================================

# Create slideshow from images (1 image per second)
# ffmpeg -r 1 -i img_%03d.jpg -c:v libx264 -r 30 -pix_fmt yuv420p slideshow.mp4

# Create video with specific duration per image (3 seconds each)
# ffmpeg -r 1/3 -i img_%03d.jpg -c:v libx264 -r 30 -pix_fmt yuv420p slideshow_3s.mp4

# Create video with crossfade transitions
# ffmpeg -loop 1 -t 3 -i img1.jpg -loop 1 -t 3 -i img2.jpg -filter_complex "[0:v][1:v]xfade=transition=fade:duration=1:offset=2[v]" -map "[v]" -t 5 crossfade.mp4


# =============================================================================
# BATCH OPERATIONS
# =============================================================================

# Batch resize all JPGs in directory
# for i in *.jpg; do ffmpeg -i "$i" -vf scale=800:-1 -q:v 3 "resized_$i"; done

# Batch convert PNG to JPG
# for i in *.png; do ffmpeg -i "$i" -q:v 3 "${i%.*}.jpg"; done

# Batch compress images
# for i in *.jpg; do ffmpeg -i "$i" -q:v 8 "compressed_$i"; done

# Batch convert to WebP
# for i in *.jpg; do ffmpeg -i "$i" -c:v libwebp -quality 80 "${i%.*}.webp"; done

# Batch add watermark
# for i in *.jpg; do ffmpeg -i "$i" -vf drawtext="fontfile=/System/Library/Fonts/Arial.ttf:text='© 2025':fontsize=16:fontcolor=white@0.7:x=w-tw-10:y=h-th-10" "watermarked_$i"; done

# Batch grayscale conversion
# for i in *.jpg; do ffmpeg -i "$i" -vf format=gray "bw_$i"; done


# =============================================================================
# GETTING IMAGE INFORMATION
# =============================================================================

# Get image dimensions
# ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 input.jpg

# Get detailed image info (JSON format)
# ffprobe -v quiet -print_format json -show_format -show_streams input.jpg

# Get image format
# ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 input.jpg

# Get color space info
# ffprobe -v error -select_streams v:0 -show_entries stream=color_space,color_primaries -of default=noprint_wrappers=1 input.jpg

# Check if image has transparency (alpha channel)
# ffprobe -v error -select_streams v:0 -show_entries stream=pix_fmt -of default=noprint_wrappers=1:nokey=1 input.png


# =============================================================================
# FORMAT-SPECIFIC OPERATIONS
# =============================================================================

# Create high-quality PNG from JPG (with transparency support)
# ffmpeg -i input.jpg -pix_fmt rgba output.png

# Convert to different bit depths
# ffmpeg -i input.jpg -pix_fmt rgb565 output_16bit.jpg   # 16-bit
# ffmpeg -i input.png -pix_fmt rgb24 output_24bit.png    # 24-bit
# ffmpeg -i input.jpg -pix_fmt rgb48be output_48bit.png  # 48-bit

# Create progressive JPEG
# ffmpeg -i input.jpg -c:v mjpeg -q:v 3 -huffman optimal progressive.jpg

# Create interlaced PNG
# ffmpeg -i input.jpg -c:v png -compression_level 9 interlaced.png


# =============================================================================
# ADVANCED FILTERS
# =============================================================================

# Apply multiple filters at once
# ffmpeg -i input.jpg -vf scale=800:-1,eq=brightness=0.1:contrast=1.2,unsharp=5:5:1.0 enhanced.jpg

# Edge detection
# ffmpeg -i input.jpg -vf edgedetect edges.jpg

# Emboss effect
# ffmpeg -i input.jpg -vf convolution="0 -1 0:-1 5 -1:0 -1 0:0 -1 0:-1 5 -1:0 -1 0" emboss.jpg

# Oil painting effect
# ffmpeg -i input.jpg -vf "format=yuv420p,boxblur=2:1,unsharp" oil_painting.jpg

# Vignette effect
# ffmpeg -i input.jpg -vf vignette=PI/4 vignette.jpg

# Fisheye effect
# ffmpeg -i input.jpg -vf "format=rgba,geq=r='st(0,pow(cos(atan2(Y-H/2,X-W/2)),2));if(ld(0),r(X*ld(0)+(1-ld(0))*W/2,Y*ld(0)+(1-ld(0))*H/2),0)':g='st(0,pow(cos(atan2(Y-H/2,X-W/2)),2));if(ld(0),g(X*ld(0)+(1-ld(0))*W/2,Y*ld(0)+(1-ld(0))*H/2),0)':b='st(0,pow(cos(atan2(Y-H/2,X-W/2)),2));if(ld(0),b(X*ld(0)+(1-ld(0))*W/2,Y*ld(0)+(1-ld(0))*H/2),0)'" fisheye.jpg


# =============================================================================
# NOTES
# =============================================================================
# Quality settings for JPEG: -q:v 1 (best) to -q:v 31 (worst)
# For batch operations, always test on a single file first
# Use -y flag to overwrite output files without asking
# Use -n flag to never overwrite output files
# PNG compression levels: 0 (fastest) to 9 (best compression)
# WebP quality: 0 (worst) to 100 (best), lossless mode available
# Font paths vary by system:
#   macOS: /System/Library/Fonts/ or /Library/Fonts/
#   Linux: /usr/share/fonts/ or ~/.fonts/
#   Windows: C:/Windows/Fonts/

