# main.py

import multiprocessing
from bandwidth_manager import monitor_bandwidth
from cpu_optimizer import optimize_cpu_usage
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def main():
    try:
        limit_mb = int(input("Enter bandwidth limit (MB): "))
    except ValueError:
        logging.error("Invalid value. Please enter an integer.")
        return

    cpu_process = multiprocessing.Process(target=optimize_cpu_usage)
    cpu_process.start()

    try:
        monitor_bandwidth(limit_mb)
    finally:
        cpu_process.terminate()
        cpu_process.join()

if __name__ == "__main__":
    main()
