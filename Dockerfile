# Stage 1: Build environment
FROM public.ecr.aws/lambda/python:3.8 AS builder

WORKDIR /build

COPY requirements.txt app.py ./ 
#COPY cache_folder/ ./cache_folder

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt --target /build && \
    find /usr/local -name '*.pyc' -delete

# Stage 2: Final image
FROM public.ecr.aws/lambda/python:3.8

# Consolidate installation and cleanup in a single RUN command
RUN yum install -y mesa-libGL mesa-libGLU libglib2.0-0 && \
    yum clean all && \
    rm -rf /var/cache/yum

# Copy the built artifacts from the builder stage
COPY --from=builder /build ${LAMBDA_TASK_ROOT}
COPY cache_folder/ /root/.cache/huggingface/hub/models--CompVis--stable-diffusion-safety-checker/

COPY deliberate_v2.safetensors ./

CMD ["app.handler"]
