FROM vishva123/nvidia-cuda-13.0.2-cudnn-devel-ubuntu24.04-python-3.12

RUN pip install --upgrade pip uv

RUN uv pip install --system \ 
    "vllm[audio,video]==0.13.0" --torch-backend=cu128

RUN uv pip install --system \ 
    flashinfer-python --no-cache-dir \
    flash-attn --no-build-isolation

EXPOSE 8000

ENTRYPOINT ["vllm", "serve"]