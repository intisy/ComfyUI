#!/bin/bash

VENV_DIR="venv"

echo "--- ComfyUI Launcher for AMD RX 5700XT ---"

# Check if virtual environment directory exists
if [ ! -d "$VENV_DIR" ] || [ ! -f "$VENV_DIR/bin/activate" ]; then
    echo "Error: Virtual environment not found or is invalid at $VENV_DIR"
    echo "Make sure '$VENV_DIR/bin/activate' exists."
    echo "Please edit this script and set the VENV_DIR variable correctly."
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment: $VENV_DIR"
source "$VENV_DIR/bin/activate"
if [ $? -ne 0 ]; then
    echo "Error: Failed to activate virtual environment."
    exit 1
fi
echo "Virtual environment activated."
echo "Python version in venv: $(python --version)"

# Set environment variable for RX 5700 XT
echo "Setting HSA_OVERRIDE_GFX_VERSION=10.3.0"
#export HSA_OVERRIDE_GFX_VERSION=10.3.0

# Launch ComfyUI
echo "Starting ComfyUI..."
echo "You can pass additional arguments to ComfyUI, e.g., ./start_comfyui_amd.sh --listen --port 8888"
echo "To stop ComfyUI, press Ctrl+C in this terminal."

python main.py "$@"

echo "ComfyUI has exited."

exit 0
