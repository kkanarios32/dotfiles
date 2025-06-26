#!./.venv/bin/python3

import click
import time

from surya.logging import configure_logging, get_logger
from surya.scripts.config import CLILoader
from surya.recognition import RecognitionPredictor
from surya.common.surya.schema import TaskNames
from surya.input.load import load_image
import re


def html_math_to_latex(text):
    # Match <math display="block">...</math> and extract the math content
    pattern = r'<math[^>]*display="block"[^>]*>(.*?)</math>'

    def replacer(match):
        math_content = match.group(1).strip()
        # Replace ||...|| with \left\|...\right\| (optional but recommended)
        return f"\\[\n{math_content}\n\\]"

    return re.sub(pattern, replacer, text, flags=re.DOTALL)


configure_logging()
logger = get_logger()


@click.command(help="OCR LaTeX equations.")
@CLILoader.common_options
def ocr_latex_cli(input_path: str, **kwargs):
    (image, name) = load_image(input_path)

    texify_predictor = RecognitionPredictor()
    task = [TaskNames.block_without_boxes]
    bboxes = [[[0, 0, image[0].width, image[0].height]]]

    start = time.time()
    prediction = texify_predictor(
        image,
        task,
        bboxes=bboxes,
    )

    latex_prediction = prediction[0].text_lines[0].text
    latex_prediction = html_math_to_latex(latex_prediction)
    print(latex_prediction)
    # latex_prediction = pypandoc.convert_text(latex_prediction, "plain", format="md")

    debug = False
    if debug:
        logger.debug(f"OCR took {time.time() - start:.2f} seconds")

    # out_preds = defaultdict(list)
    # for name, pred, image in zip(loader.names, latex_predictions, loader.images):
    #     out_pred = {
    #         "equation": pred,
    #         "page": len(out_preds[name]) + 1,
    #     }
    #     out_preds[name].append(out_pred)
    #
    # with open(
    #     os.path.join(loader.result_path, "results.json"), "w+", encoding="utf-8"
    # ) as f:
    #     json.dump(out_preds, f, ensure_ascii=False)
    #
    # logger.info(f"Wrote results to {loader.result_path}")


if __name__ == "__main__":
    ocr_latex_cli()
