# DaVinci Resolve Converter

A lightweight bash script that converts video files through a two-stage workflow optimized for DaVinci Resolve editing and device playback.

## The Problem

DaVinci Resolve on Linux has known issues with certain codecs and formats:

- **Import issues**: Clips recorded in certain formats won't import into DaVinci Resolve
- **Export issues**: Exported clips from DaVinci Resolve don't play properly on mobile devices

## The Solution

Two-stage workflow:

1. **Stage 1**: Any format → ProRes Proxy `.mov` (for DaVinci editing)
2. **Stage 2**: DaVinci export (ProRes `.mov`) → H.264 MP4 (for mobile/web)

Drop your video in the staging folder and the script automatically detects which stage to run based on the filename.

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

### 3. Workflow stages

**Stage 1 - For DaVinci editing:**
- Input: Any video format
- Output: `*_DaVinci.mov` (ProRes Proxy)
- Use this file in DaVinci Resolve

**Stage 2 - For devices:**
- Input: Exported ProRes `.mov` from DaVinci
- Important: Rename the file to include `_DaVinci.mov` in the filename (e.g., `project_DaVinci.mov`)
- The script detects this suffix to trigger Stage 2 conversion
- Output: `*_device.mp4` (H.264)
- Playable on Android, iOS, web browsers, smart TVs

## Offline Operation

This script works **100% offline**. FFmpeg processes everything locally on your machine - no internet connection required, no cloud uploads, no telemetry.

## Output Formats

### Stage 1: ProRes Proxy (.mov)
| Property | Value |
|----------|-------|
| Container | MOV |
| Video codec | ProRes Proxy (profile 0) |
| Audio codec | PCM 16-bit |
| Pixel format | yuv422p10le |

### Stage 2: H.264 MP4
| Property | Value |
|----------|-------|
| Container | MP4 |
| Video codec | H.264 (libx264) |
| Audio codec | AAC 192kbps |
| Pixel format | yuv420p |
| Quality | CRF 18 (high quality) |
| Compatibility | Android, iOS, web browsers, smart TVs |

## Folder Structure

```
davinci-resolve-converter/
├── convert.sh       # Main script
├── staging/         # Drop videos here
└── converted/       # Converted files appear here
```

## Help

```bash
./convert.sh --help
```

## License

MIT License - free to use, modify, and share.