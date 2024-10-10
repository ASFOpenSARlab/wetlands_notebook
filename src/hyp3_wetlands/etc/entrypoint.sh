#!/bin/bash --login
set -e
conda activate NISAR_EA_Workshop_2024_10
exec python -um hyp3_wetlands "$@"
