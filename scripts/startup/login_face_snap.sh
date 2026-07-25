# Take an Image of me
! test -d "${picture_dir}/login_pictures" && mkdir -p "${picture_dir}/login_pictures"
hash ffmpeg && ffmpeg -v quiet -f video4linux2 -input_format mjpeg -video_size 1280x720 -i /dev/video0 -vframes 1 "${picture_dir}/login_pictures/$(date +%Y-%m-%dT%H).png" &
