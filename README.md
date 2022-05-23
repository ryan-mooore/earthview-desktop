# Earthview Desktop

A simple bash script replacing your macOS desktop wallpaper with a random handpicked aerial image of the Earth, via [Earth View with Google](https://earthview.withgoogle.com).

![](images/example.png)

## Installation and Execution

```bash
chmod +x earthview.sh
./earthview.sh
```

On execution the script will generate the folder `current` in the working directory, which includes:

- A Google Earth link to the location
- A `.txt` file including place name and coordinates
- The original and annotated aerial image
  The script will also set the image as your desktop background by default. Comment out the last 3 lines of the script to prevent this.

### Dependencies

- jq
- ImageMagick >= 6

### Usage

`./earthview.sh [-a ANNOTATE] [-s TEXT_SIZE]`

`ANNOTATE` can be any of the cardinal directions (default: `southwest`)

### Setting as cronjob

The script can be set up as cron job to create a dynamically changing wallpaper.
e.g. adding `0 * * * * bash -l /path/to/earthview.sh` to your crontab will change the wallpaper every hour.
