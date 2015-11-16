# SLA Monitoring for Basecamp Classic

This is a small script to calculate SLAs based on standard 24 / 48 hours segmentation.

Usage is embedded in the script:

    Usage: sla.rb [options]
            --endpoint ENDPOINT          Basecamp Endpoint
                                         Default: eduvo.basecamphq.com
            --key API_KEY                Basecamp API Key
                                         See: https://zapier.com/help/basecamp-classic#how-get-started-basecamp-classic
            --project PROJECT_ID         Basecamp Project ID

To use this script, first clone the repository, then run `bundle install`. Afterwards you can use `./sla.rb` to compute SLA requirements.
