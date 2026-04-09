#!/bin/bash
# DaVinci Resolve Video Converter
# Converts videos to H.264 MP4 for universal playback (Android, iOS, web, etc.)

STAGING_DIR="$HOME/Videos/Davinci-Converter/staging"
CONVERTED_DIR="$HOME/Videos/Davinci-Converter/converted"
LOG_FILE="$HOME/Videos/Davinci-Converter/convert.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [ ! -d "$STAGING_DIR" ]; then
    mkdir -p "$STAGING_DIR"
fi

if [ ! -d "$CONVERTED_DIR" ]; then
    mkdir -p "$CONVERTED_DIR"
fi

convert_video() {
    local input_file="$1"
    local filename=$(basename "$input_file")
    local name="${filename%.*}"
    local output_file="$CONVERTED_DIR/${name}.mp4"
    
    if [ -f "$output_file" ]; then
        log "${YELLOW}Skipping (already exists): $filename${NC}"
        return 0
    fi
    
    local codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$input_file" 2>/dev/null)
    
    log "${GREEN}Converting: $filename${NC}"
    log "Codec: $codec -> H.264/MP4"
    
    if ffmpeg -i "$input_file" \
        -c:v libx264 -preset slow -crf 18 \
        -c:a aac -b:a 192k \
        -pix_fmt yuv420p \
        -movflags +faststart \
        -y "$output_file" 2>&1 | tee -a "$LOG_FILE"; then
        log "${GREEN}SUCCESS: $filename -> ${name}.mp4${NC}"
        rm "$input_file"
        log "Removed original: $input_file"
    else
        log "${RED}FAILED: $filename${NC}"
        return 1
    fi
}

process_folder() {
    log "========================================="
    log "Checking staging folder..."
    
    local count=0
    
    for file in "$STAGING_DIR"/*; do
        [ -f "$file" ] || continue
        
        filename=$(basename "$file")
        
        case "${filename,,}" in
            *.mp4|*.mov|*.mkv|*.avi|*.m4v|*.webm|*.wmv|*.flv|*.3gp)
                convert_video "$file"
                ((count++))
                ;;
            *)
                log "${YELLOW}Skipping non-video file: $filename${NC}"
                ;;
        esac
    done
    
    if [ $count -eq 0 ]; then
        log "No videos to convert."
    else
        log "Processed $count video(s)."
    fi
}

show_usage() {
    echo "DaVinci Resolve Video Converter (H.264/MP4)"
    echo "============================================"
    echo ""
    echo "Usage:"
    echo "  $0           - Process all videos in staging folder"
    echo "  $0 --watch   - Watch staging folder continuously"
    echo "  $0 --help    - Show this help"
    echo ""
    echo "Folders:"
    echo "  Staging:    $STAGING_DIR"
    echo "  Converted:  $CONVERTED_DIR"
    echo ""
    echo "Output: H.264 MP4 (plays on Android, iOS, web, etc.)"
    echo "Quality: CRF 18 (high quality), preset slow (smaller file)"
}

case "${1:-}" in
    --watch|-w)
        log "Starting watch mode (Ctrl+C to stop)"
        log "Watching: $STAGING_DIR"
        while true; do
            process_folder
            sleep 5
        done
        ;;
    --help|-h)
        show_usage
        ;;
    *)
        process_folder
        ;;
esac
