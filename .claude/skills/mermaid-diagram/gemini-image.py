#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["google-genai", "pillow"]
# ///
"""Generate an image from a text prompt using Gemini."""

import argparse
import os
import sys

from google import genai
from google.genai import types

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
    args = parser.parse_args()

    output_path = args.output
    prompt = " ".join(args.prompt)

    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY environment variable not set", file=sys.stderr)
        sys.exit(1)

    client = genai.Client(api_key=api_key)
    response = client.models.generate_content(
        model=MODELS[args.model],
        contents=[prompt],
        config=types.GenerateContentConfig(
            response_modalities=["TEXT", "IMAGE"],
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
