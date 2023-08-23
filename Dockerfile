# Stage 1: Build environment
FROM python:3.11.4-slim AS build

WORKDIR /app

COPY requirements.txt /app/
COPY generate_image.py /app/

# Install system libraries for graphical applications
RUN apt-get update && \
    apt-get install -y libgl1-mesa-glx libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir virtualenv && \
    virtualenv /app/venv && \
    /app/venv/bin/pip install --no-cache-dir -r requirements.txt

COPY . /app/

# Stage 2: Final runtime environment
FROM python:3.11.4-slim

WORKDIR /app

COPY --from=build /app/venv /app/venv
COPY --from=build /app/generate_image.py /app/

# Set up environment variables and command
ENV PATH="/app/venv/bin:$PATH"

# Copy deliberate_v2.safetensors into the container at runtime
COPY deliberate_v2.safetensors /app/

# Install system libraries for graphical applications
RUN apt-get update && \
    apt-get install -y libgl1-mesa-glx libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

CMD ["python", "generate_image.py"]
