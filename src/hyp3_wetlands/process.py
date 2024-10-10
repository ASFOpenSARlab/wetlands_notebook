"""
wetlands processing
"""

import argparse
import logging
from datetime import datetime
from pathlib import Path

import papermill as pm

from hyp3_wetlands import __version__

log = logging.getLogger(__name__)


def process_wetlands() -> Path:
    """Run the NISAR ATBD wetlands notebook."""
    notebook_path = Path(__file__).parent / 'etc' / 'NISAR_ATBD_wetlands.ipynb'
    executed_notebook = Path.cwd() / f'{notebook_path.stem}_{datetime.now()}.ipynb'
    pm.execute_notebook(
        notebook_path,
        executed_notebook,
        kernel_name='python3',
    )
    
    return executed_notebook
