FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-runtime
# cd to workspace (to make sure)
WORKDIR /workspace

RUN apt-get update -y; apt-get install git -y
# Download and install necessary packages.
RUN git clone https://github.com/xinntao/Real-ESRGAN.git
WORKDIR /workspace/Real-ESRGAN
# We use BasicSR for both training and inference
RUN pip install basicsr
# facexlib and gfpgan are for face enhancement
RUN pip install facexlib
RUN pip install gfpgan
RUN pip install -r requirements.txt
RUN python setup.py develop
RUN mkdir /workspace/source_dir
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6 curl -y
RUN curl -o /workspace/Real-ESRGAN/weights/RealESRGAN_x4plus.pth -LO https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth 


# Get arguments from the run command can also be accessed with $1 and $2
# IN_FILE and OUT_FILE are env varaibles accessed from the docker run command.
# to configure the container when it starts (only during running the container) and it cant be overriden as entrypoint is used instead of CMD.
# Given the image name, run the GAN on the image and save the ouput in the source directory (source_dir)
# CMD echo "The input image name is : $IN_FILE" && echo "The output image name is : $OUT_FILE"
ENTRYPOINT ["bash", "-c", "python inference_realesrgan.py -n RealESRGAN_x4plus -i /workspace/source_dir/$IN_FILE ; mv /workspace/Real-ESRGAN/results/*out* /workspace/source_dir/$OUT_FILE"] 