# Docker vLLM Server Builder

This repository contains Dockerfiles and build configurations for running the **vLLM OpenAI-compatible inference server** with NVIDIA CUDA, cuDNN, and Python 3.12.  
All images are optimized for high-performance GPU inference with large language models and embedding models.

Base image example:
```

vishva123/nvidia-cuda-13.0.2-cudnn-devel-ubuntu24.04-python-3.12

````

---

## 🚀 Features
- CUDA 12.x / 13.x + cuDNN enabled
- Python 3.12
- vLLM `0.15.0`
- Flash Attention + FlashInfer support
- Optimized for:
  - Large context models (32k+)
  - Quantized models (AWQ / Marlin)
  - Multi-model serving (LLMs + embedding models)
- Fully compatible with official vLLM CLI:
  https://docs.vllm.ai/en/v0.15.0/cli/serve/

---

## 📦 Dockerfile Example

```dockerfile
FROM vishva123/nvidia-cuda-13.0.2-cudnn-devel-ubuntu24.04-python-3.12

RUN pip install --upgrade pip uv

RUN uv pip install --system \
    "vllm[audio,video]==0.15.0" --torch-backend=cu128

RUN uv pip install --system \
    flashinfer-python --no-cache-dir \
    flash-attn --no-build-isolation

EXPOSE 8000
ENTRYPOINT ["vllm", "serve"]
````

---

## 🧠 Running vLLM with Docker Compose

```yaml
services:
  vllm:
    image: vishva123/vllm-server-cuda-13.0.2
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=compute,utility
      - VLLM_USE_V1=0
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    ipc: host
    ports:
      - "8000:8000"
    command:
      - "Qwen/Qwen3-14B-AWQ"
      - "--quantization"
      - "awq_marlin"
      - "--max-model-len"
      - "32768"
      - "--gpu-memory-utilization"
      - "0.80"
      - "--kv-cache-dtype"
      - "fp8"
```

---

## 🔢 Embedding Model with Runner Pooling

Use `--runner pooling` for embedding models:

```yaml
command:
  - "BAAI/bge-m3"
  - "--runner"
  - "pooling"
  - "--gpu-memory-utilization"
  - "0.40"
```

---

## 🗂 Published Docker Images

All images are available under the **vishva123** namespace:

| Image                               | CUDA   | Status |
| ----------------------------------- | ------ | ------ |
| `vishva123/vllm-server-cuda-13.0.2` | 13.0.2 | Public |
| `vishva123/vllm-server-cuda-12.8.1` | 12.8.1 | Public |
| `vishva123/vllm-server-cuda-12.6.3` | 12.6.3 | Public |

---

## 🎯 Purpose

This repository acts as a **builder and reference** for creating optimized vLLM Docker images that:

* Work reliably on consumer GPUs (RTX 3090, 4090, etc.)
* Support large context windows
* Run production-grade inference servers

---

## 🧑‍💻 Author

**Vishva Murthy**
Generative AI Engineer | GPU Inference | RAG | vLLM | LightRAG
