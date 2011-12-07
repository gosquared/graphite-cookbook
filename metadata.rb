maintainer        "Gerhard Lazu"
maintainer_email  "gerhard@lazu.co.uk"
license           "Apache 2.0"
description       "Installs and configures Graphite"
version           "0.9.9"

recipe "graphite", "Installs all 3 Graphite components: whisper, carbon & web"

supports "ubuntu"

depends "python"    # https://github.com/gchef/python-cookbook
depends "bootstrap" # https://github.com/gchef/bootstrap
# depends "apache2"
