# Stage 1: Build environment
FROM public.ecr.aws/lambda/python:3.8


COPY requirements.txt ${LAMBDA_TASK_ROOT}
COPY app.py ${LAMBDA_TASK_ROOT}
COPY /cache_folder /root/.cache/huggingface/hub/models--CompVis--stable-diffusion-safety-checker/
COPY deliberate_v2.safetensors ${LAMBDA_TASK_ROOT}


RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

RUN yum install -y mesa-libGL mesa-libGLU libglib2.0-0


CMD ["app.handler"]
