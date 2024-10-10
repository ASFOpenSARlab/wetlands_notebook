"""
wetlands processing for HyP3
"""
import logging
from argparse import ArgumentParser

from hyp3lib.aws import upload_file_to_s3

from hyp3_wetlands.process import process_wetlands


def main():
    """
    HyP3 entrypoint for hyp3_wetlands
    """
    parser = ArgumentParser()
    parser.add_argument('--bucket', help='AWS S3 bucket HyP3 for upload the final product(s)')
    parser.add_argument('--bucket-prefix', default='', help='Add a bucket prefix to product(s)')
    args = parser.parse_args()

    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p', level=logging.INFO)

    executed_notebook = process_wetlands()

    if args.bucket:
        upload_file_to_s3(executed_notebook, args.bucket, args.bucket_prefix)


if __name__ == '__main__':
    main()
