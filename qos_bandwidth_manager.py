import psutil
import time
import subprocess
import logging
import sys
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

def get_process_bandwidth(proc: psutil.Process) -> tuple[int, int]:
    try:
        io_counters = proc.io_counters()
        return io_counters.read_bytes, io_counters.write_bytes
    except (psutil.NoSuchProcess, psutil.AccessDenied) as e:
        logging.error(f"Error getting bandwidth: {e}")
        return 0, 0

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
        policy_applied = False
        initial_read, initial_write = get_process_bandwidth(proc)
        last_check_time = time.time()
        
        while True:
            time.sleep(CHECK_INTERVAL)
            
            if not psutil.pid_exists(proc.pid):
                logging.error(f"{PROCESS_NAME} is no longer running. Exiting.")
                break
            
            current_time = time.time()
            elapsed_time = current_time - last_check_time
            current_read, current_write = get_process_bandwidth(proc)
            
            if elapsed_time > 0:
                read_bandwidth = (current_read - initial_read) / elapsed_time / 1024 / 1024  # MB/s
                write_bandwidth = (current_write - initial_write) / elapsed_time / 1024 / 1024  # MB/s
                total_bandwidth = read_bandwidth + write_bandwidth
            else:
                read_bandwidth = write_bandwidth = total_bandwidth = 0
            
            logging.info(f"Read: {read_bandwidth:.2f} MB/s, Write: {write_bandwidth:.2f} MB/s, Total: {total_bandwidth:.2f} MB/s")
            
            if total_bandwidth > LIMIT_MB / 8 and not policy_applied:
                logging.warning(f"Current bandwidth: {total_bandwidth:.2f} MB/s exceeds limit. Applying QoS policy.")
                apply_qos_policy(LIMIT_MB)
                policy_applied = True
            elif total_bandwidth <= LIMIT_MB / 8 and policy_applied:
                logging.info(f"Current bandwidth: {total_bandwidth:.2f} MB/s is within the limit. Removing QoS policy.")
                remove_qos_policy()
                policy_applied = False

            initial_read, initial_write = current_read, current_write
            last_check_time = current_time

    except KeyboardInterrupt:
        logging.info("Monitoring stopped by user.")
    except Exception as e:
        logging.exception(f"An unexpected error occurred: {e}")
    finally:
        if policy_applied:
            remove_qos_policy()

# Set up logging to both console and file
log_formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
log_file = 'bandwidth_monitor.log'
file_handler = logging.FileHandler(log_file)
file_handler.setFormatter(log_formatter)
console_handler = logging.StreamHandler(sys.stdout)
console_handler.setFormatter(log_formatter)
logging.getLogger().addHandler(file_handler)
logging.getLogger().addHandler(console_handler)

if __name__ == '__main__':
    main()

print("Script execution completed.")
