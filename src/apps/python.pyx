## python.pyx
## Copyright 2016 Mac Radigan
## All Rights Reserved

from IPython.terminal.ipapp import TerminalIPythonApp
from IPython.config.configurable import Configurable

app = TerminalIPythonApp.instance()
app.display_banner = False
app.initialize(argv=[])
app.start()

## *EOF*
