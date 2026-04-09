# DaVinci Resolve Converter

A lightweight bash script that converts video files to H.264 MP4 format. Built specifically to solve codec and format compatibility issues with DaVinci Resolve on Linux.

## The Problem

DaVinci Resolve on Linux has known issues with certain codecs and formats when importing and exporting video clips:

- **Import issues**: Clips recorded in certain formats won't import into DaVinci Resolve
- **Export issues**: Exported clips from DaVinci Resolve don't play properly on some devices, especially mobile

## The Solution

Drop your problematic video into the staging folder and this script converts it to a format that works:

- If a clip won't import into davinci resolve,convert it first, then import
- If an exported clip won't play on mobile,convert to universal H.264 MP4

The script also doubles as an excellent video compression utility, reducing video size by upto 95%.

## Prerequisites

- **FFmpeg** installed on your system

### Install FFmpeg

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install ffmpeg
```

**Fedora:**
```bash
sudo dnf install ffmpeg
```

**Arch:**
```bash
sudo pacman -S ffmpeg
```

**macOS:**
```bash
brew install ffmpeg
```

## Installation

1. Download or clone this repository
2. Navigate to the folder:
   ```bash
   cd davinci-resolve-converter
   ```
3. Make the script executable:
   ```bash
   chmod +x convert.sh
   ```

## Usage

### 1. Drop videos into the staging folder

Place any video file into the `staging/` folder. Supported formats:
`.mp4`, `.mov`, `.mkv`, `.avi`, `.m4v`, `.webm`, `.wmv`, `.flv`, `.3gp`

### 2. Run the converter

**Single pass (processes videos once):**
```bash
./convert.sh
```

**Watch mode (continuous monitoring):**
```bash
./convert.sh --watch
```
The script will check the staging folder every 5 seconds. Great for batch processing.

### 3. Get your converted videos

Converted files appear in the `converted/` folder as H.264 MP4s.

## Offline Operation

This script works **100% offline**. FFmpeg processes everything locally on your machine - no internet connection required, no cloud uploads, no telemetry.

## Output Format

| Property | Value |
|----------|-------|
| Container | MP4 |
| Video codec | H.264 (libx264) |
| Audio codec | AAC 192kbps |
| Pixel format | yuv420p |
| Quality | CRF 18 (high quality) |
| Compatibility | Android, iOS, web browsers, smart TVs |

The `yuv420p` pixel format and H.264 codec ensure maximum compatibility across devices.

## Folder Structure

```
davinci-resolve-converter/
├── convert.sh       # Main script
├── staging/         # Drop videos here
└── converted/       # Converted MP4s appear here
```

## Help

```bash
./convert.sh --help
```

## License

MIT License - free to use, modify, and share.
