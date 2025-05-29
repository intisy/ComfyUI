#!/bin/bash

# --- Configuration ---
# PLEASE SET THESE PATHS CORRECTLY FOR YOUR SYSTEM

# 1. Set the full path to your ComfyUI installation directory
COMFYUI_DIR="/mnt/nvme_data/Documents/GitHub/ComfyUI" # Change this to your actual ComfyUI path

# 2. Set the full path to your Python virtual environment directory for ComfyUI
# If your venv is named "venv" and is INSIDE your ComfyUI directory:
VENV_DIR="$COMFYUI_DIR/venv"
# If your venv is located elsewhere, set the full path, e.g.:
# VENV_DIR="/path/to/your/sdxl_env"

# --- End of Configuration ---

echo "--- ComfyUI Launcher for AMD RX 5700XT ---"

# Check if ComfyUI directory exists
if [ ! -d "$COMFYUI_DIR" ]; then
    echo "Error: ComfyUI directory not found at $COMFYUI_DIR"
    echo "Please edit this script and set the COMFYUI_DIR variable correctly."
    exit 1
fi

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
export HSA_OVERRIDE_GFX_VERSION=10.3.0

# Navigate to ComfyUI directory
echo "Changing directory to $COMFYUI_DIR"
cd "$COMFYUI_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to change directory to $COMFYUI_DIR"
    # Attempt to deactivate venv if cd fails after activation
    deactivate &> /dev/null
    exit 1
fi

# Launch ComfyUI
echo "Starting ComfyUI..."
echo "You can pass additional arguments to ComfyUI, e.g., ./start_comfyui_amd.sh --listen --port 8888"
echo "To stop ComfyUI, press Ctrl+C in this terminal."

# The "$@" passes any arguments given to this launch script directly to main.py
python main.py "$@"

echo "ComfyUI has exited."

# Deactivate virtual environment (optional, as the script is ending)
# If the venv was sourced, it will remain active in the terminal if the script
# was sourced. If the script was executed directly, the venv deactivates
# when the script's shell instance closes. Explicit deactivation can be added if desired.
# echo "Deactivating virtual environment (if script was sourced)..."
# deactivate &> /dev/null # Suppress output from deactivate if it's noisy

exit 0
