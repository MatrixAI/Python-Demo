 sys
 argparse
 logging


   verbose_to_loglevel( :  ) -   :
    loglevel  logging.WARNING
      c   1:
        loglevel   logging.INFO
        c >= 2:
        loglevel   logging.DEBUG
          loglevel


   main(args=sys.argv[1:]):
    options_parser  argparse.ArgumentParser()
    options_parser.add_argument(
        "-v", "--verbose", help="Log Verbose Messages", action="count", default=0
    )
    options  options_parser.parse_args(args)
    logging.basicConfig(level=verbose_to_loglevel(options.verbose))
    logger  logging.getLogger(__name__)
    logger.info("Hello World")


   __name__  "__main__"
    main()
