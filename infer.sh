while getopts i: opt; do
    case "${opt}" in
        i) input_img_path=${OPTARG};;
    esac
done
if [ -z "$input_img_path" ]; then
    echo "Error, please provide an image with -i."
    exit 1
fi
echo "Apply ESRGAN to the image at $input_img_path"

# Get absolute path for any case
real_input_img_path=$(realpath "$input_img_path")
echo "Image is located at: " $real_input_img_path
source_directory=$(dirname "$real_input_img_path")
echo "The source directory is: " $source_directory
file_name=$(basename "$real_input_img_path")
echo "The image name is: " $file_name

# The directory of the image should be shared with the container somehow. And the container should output the image to the same directory.
# source and target will have the exact same contents.
docker run -it --gpus device=0 --mount type=bind,source=$source_directory,target=/workspace/source_dir --env IN_FILE=$file_name --env OUT_FILE="out.png"  utkutpcgl/esrgan:v1
# python inference_realesrgan.py -n RealESRGAN_x4plus -i /workspace/source_dir/0014.jpg