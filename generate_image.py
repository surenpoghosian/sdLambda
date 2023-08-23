import sdkit
from sdkit.models import load_model
from sdkit.generate import generate_images
from sdkit.utils import save_images, log
import datetime


def generate_image():
    context = sdkit.Context()

    # set the path to the model file on the disk (.ckpt or .safetensors file)

    context.model_paths['stable-diffusion'] = './deliberate_v2.safetensors'

    load_model(context, 'stable-diffusion')

    # generate the image
    images = generate_images(context, prompt='Photograph of a biker riding a horse', seed=69, width=768, height=768)

    # save the image
    save_images(images, dir_path='./images')

    log.info("Generated images!")




generate_image()
