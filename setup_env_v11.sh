#!/bin/bash

cd /workspace
. /venv/main/bin/activat

ENV_NAME="main"
# ENV_NAME="code-agent-v11"

echo "------------------------------ Create ENV ------------------------------"
# conda create -n $ENV_NAME python=3.12 -y

echo "------------------------------ Install Libraries ------------------------------"
conda run -n $ENV_NAME pip install langchain==0.3.27
conda run -n $ENV_NAME pip install langchain-community==0.3.27
conda run -n $ENV_NAME pip install langchain-core==0.3.74
conda run -n $ENV_NAME pip install vllm==0.10.0
conda run -n $ENV_NAME pip install PyYAML==6.0.2
conda run -n $ENV_NAME pip install pydantic==2.11.7
conda run -n $ENV_NAME pip install uvicorn==0.35.0
