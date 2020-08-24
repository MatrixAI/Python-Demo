import sys
import argparse
import logging


def verbose_to_loglevel(c: int) -> int:
    loglevel = logging.WARNING
    if c == 1:
        loglevel = logging.INFO
    elif c >= 2:
        loglevel = logging.DEBUG
    return loglevel


def main(args=sys.argv[1:]):
    options_parser = argparse.ArgumentParser()
    options_parser.add_argument(
        "-v", "--verbose", help="Log Verbose Messages", action="count", default=0
    )
    options = options_parser.parse_args(args)
    logging.basicConfig(level=verbose_to_loglevel(options.verbose))
    logger = logging.getLogger(__name__)
    logger.info("Hello World")


if __name__ == "__main__":
    main()
