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
QOS_POLICY_NAME = "BandwidthLimitPolicy"

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

def apply_qos_policy(bandwidth_mb: int):
    try:
        # Remove existing policy if it exists
        remove_qos_policy()
        
        # Create new QoS policy
        command = f'powershell -Command "New-NetQosPolicy -Name \'{QOS_POLICY_NAME}\' -AppPathNameMatchCondition \'{PROCESS_NAME}\' -ThrottleRateActionBitsPerSecond {bandwidth_mb * 1000000}"'
        subprocess.run(command, shell=True, check=True)
        logging.info(f"QoS policy with {bandwidth_mb} MB limit applied.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to apply QoS policy: {e}")

def remove_qos_policy():
    try:
        command = f'powershell -Command "Remove-NetQosPolicy -Name \'{QOS_POLICY_NAME}\' -Confirm:$false"'
        subprocess.run(command, shell=True, check=True)
        logging.info("QoS policy removed.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to remove QoS policy: {e}")

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
                logging.warning(f"Current usage: {usage_mb:.2f} MB exceeds limit. Applying QoS policy.")
                apply_qos_policy(LIMIT_MB)
            else:
                logging.info(f"Current usage: {usage_mb:.2f} MB is within the limit.")
                if previous_usage > LIMIT_BYTES:
                    remove_qos_policy()

            previous_usage = current_usage
            time.sleep(CHECK_INTERVAL)

    except KeyboardInterrupt:
        logging.info("Monitoring stopped by user.")
        remove_qos_policy()
    except Exception as e:
        logging.exception(f"An unexpected error occurred: {e}")
    finally:
        remove_qos_policy()

if __name__ == '__main__':
    main()

print("Script execution completed.")
