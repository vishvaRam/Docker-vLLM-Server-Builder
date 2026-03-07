FROM vishva123/nvidia-cuda-12.6.1-cudnn-devel-ubuntu24.04-python-3.12

RUN pip install --upgrade pip uv

RUN uv pip install --system \ 
    "vllm[audio,video]==0.17.0" --torch-backend=cu128

EXPOSE 8000

ENTRYPOINT ["vllm", "serve"]