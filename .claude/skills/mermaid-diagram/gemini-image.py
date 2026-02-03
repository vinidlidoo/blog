#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["google-genai", "pillow"]
# ///
"""Generate an image from a text prompt using Gemini, optionally with reference images."""

import argparse
import os
import sys

from google import genai
from google.genai import types
from PIL import Image

MODELS = {
    "flash": "gemini-2.5-flash-image",
    "pro": "gemini-3-pro-image-preview",
}


def main():
    parser = argparse.ArgumentParser(description="Generate an image from a text prompt")
    parser.add_argument("output", help="Output image path (e.g., static/img/diagram.png)")
    parser.add_argument("prompt", nargs="+", help="Text prompt for image generation")
    parser.add_argument("-m", "--model", choices=MODELS.keys(), default="flash",
                        help="Model to use: flash (free tier) or pro (Nano Banana Pro)")
    parser.add_argument("-i", "--image", action="append", default=[],
                        help="Input image(s) as reference (can be repeated)")
    parser.add_argument("-s", "--size", choices=["1K", "2K"], default="1K",
                        help="Output image resolution: 1K or 2K (default: 1K)")
    parser.add_argument("-a", "--aspect-ratio", default=None,
                        help="Aspect ratio (e.g., 16:9, 3:2, 1:1)")
    args = parser.parse_args()

    output_path = args.output
    prompt = " ".join(args.prompt)

    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY environment variable not set", file=sys.stderr)
        sys.exit(1)

    contents = [prompt]
    for img_path in args.image:
        contents.append(Image.open(img_path))

    client = genai.Client(api_key=api_key)
    response = client.models.generate_content(
        model=MODELS[args.model],
        contents=contents,
        config=types.GenerateContentConfig(
            response_modalities=["TEXT", "IMAGE"],
            image_config=types.ImageConfig(
                image_size=args.size,
                **({"aspect_ratio": args.aspect_ratio} if args.aspect_ratio else {}),
            ),
        ),
    )

    for part in response.candidates[0].content.parts:
        if part.inline_data is not None:
            image = part.as_image()
            image.save(output_path)
            print(f"Saved to {output_path}")
            return

    print("Error: No image returned in response", file=sys.stderr)
    if response.candidates[0].content.parts:
        for part in response.candidates[0].content.parts:
            if part.text:
                print(f"Model said: {part.text}", file=sys.stderr)
    sys.exit(1)


if __name__ == "__main__":
    main()
