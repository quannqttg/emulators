import psutil
import time
import subprocess
import logging
from typing import Optional

# Constants
PROCESS_NAME = 'MuMuVMMHeadless.exe'
LIMIT_MB = 300
LIMIT_BYTES = LIMIT_MB * 1024 * 1024
CHECK_INTERVAL = 5  # seconds
INTERFACE_NAME = "Ethernet"

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def find_process_by_name(name: str) -> Optional[psutil.Process]:
    for proc in psutil.process_iter(['name']):
        if proc.info['name'] == name:
            return proc
    return None

def get_process_bandwidth(proc: psutil.Process) -> int:
    try:
        io_counters = proc.io_counters()
        return io_counters.read_bytes + io_counters.write_bytes
    except (psutil.NoSuchProcess, psutil.AccessDenied) as e:
        logging.error(f"Error getting bandwidth: {e}")
        return 0

def limit_bandwidth(bandwidth_mb: int):
    try:
        command = f'netsh interface ipv4 set subinterface "{INTERFACE_NAME}" mtu=1500 store=persistent'
        subprocess.run(command, shell=True, check=True)
        command = f'netsh interface ipv4 set interface "{INTERFACE_NAME}" currentbandwidth={bandwidth_mb*1000000}'
        subprocess.run(command, shell=True, check=True)
        logging.info(f"Bandwidth limit of {bandwidth_mb} MB applied.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to apply bandwidth limit: {e}")

def remove_bandwidth_limit():
    try:
        command = f'netsh interface ipv4 set subinterface "{INTERFACE_NAME}" mtu=1500 store=persistent'
        subprocess.run(command, shell=True, check=True)
        logging.info("Bandwidth limit removed.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to remove bandwidth limit: {e}")

def main():
    proc = find_process_by_name(PROCESS_NAME)
    if not proc:
        logging.error(f"{PROCESS_NAME} is not running.")
        return

    logging.info(f"Monitoring {PROCESS_NAME} with PID: {proc.pid}")

    try:
        previous_usage = 0
        while True:
            current_usage = get_process_bandwidth(proc)
            usage_mb = current_usage / (1024 * 1024)

            if current_usage > LIMIT_BYTES:
                logging.warning(f"Current usage: {usage_mb:.2f} MB exceeds limit. Applying bandwidth limit.")
                limit_bandwidth(LIMIT_MB)
            else:
                logging.info(f"Current usage: {usage_mb:.2f} MB is within the limit.")
                if previous_usage > LIMIT_BYTES:
                    remove_bandwidth_limit()

            previous_usage = current_usage
            time.sleep(CHECK_INTERVAL)

    except KeyboardInterrupt:
        logging.info("Monitoring stopped by user.")
        remove_bandwidth_limit()
    except Exception as e:
        logging.exception(f"An unexpected error occurred: {e}")
    finally:
        remove_bandwidth_limit()

if __name__ == '__main__':
    main()
