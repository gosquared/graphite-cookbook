maintainer        "Gerhard Lazu"
maintainer_email  "gerhard@lazu.co.uk"
license           "Apache 2.0"
description       "Installs and configures Graphite"
version           "1.0.4"

recipe "graphite", "Installs all 3 Graphite components: whisper, carbon & web"

supports "ubuntu"

depends "python"    # https://github.com/gosquared/python-cookbook
depends "bootstrap" # https://github.com/gchef/bootstrap
# depends "apache2"
