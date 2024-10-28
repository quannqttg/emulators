import psutil
import time
import subprocess
import logging
import sys
from typing import List, Tuple, Optional

# Constants
PROCESS_NAME = 'MuMuVMMHeadless.exe'
LIMIT_MB = 300
LIMIT_BYTES = LIMIT_MB * 1024 * 1024
CHECK_INTERVAL = 5  # seconds
QOS_POLICY_NAME = "BandwidthLimitPolicy"

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def find_process_by_name(name: str) -> List[psutil.Process]:
    processes = []
    for proc in psutil.process_iter(['name']):
        if proc.info['name'] == name:
            processes.append(proc)
    return processes

def get_process_bandwidth(proc: psutil.Process) -> Tuple[int, int]:
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
    procs = find_process_by_name(PROCESS_NAME)
    if not procs:
        logging.error(f"{PROCESS_NAME} is not running.")
        return

    logging.info(f"Monitoring {len(procs)} instance(s) of {PROCESS_NAME}.")
    
    policy_applied = False
    initial_bandwidths = [(get_process_bandwidth(proc), proc) for proc in procs]
    last_check_time = time.time()
    
    try:
        while True:
            time.sleep(CHECK_INTERVAL)

            # Check if processes are still running
            active_procs = []
            for proc in procs:
                if psutil.pid_exists(proc.pid):
                    active_procs.append(proc)
                else:
                    logging.error(f"{PROCESS_NAME} with PID {proc.pid} is no longer running.")
            
            if not active_procs:
                logging.error(f"All instances of {PROCESS_NAME} have stopped. Exiting.")
                break
            
            current_time = time.time()
            elapsed_time = current_time - last_check_time

            total_read_bandwidth = 0
            total_write_bandwidth = 0

            for (initial_read, initial_write), proc in initial_bandwidths:
                current_read, current_write = get_process_bandwidth(proc)
                read_bandwidth = (current_read - initial_read) / elapsed_time / 1024 / 1024  # MB/s
                write_bandwidth = (current_write - initial_write) / elapsed_time / 1024 / 1024  # MB/s
                
                total_read_bandwidth += read_bandwidth
                total_write_bandwidth += write_bandwidth

                # Update initial bandwidths for the next check
                initial_bandwidths[active_procs.index(proc)] = ((current_read, current_write), proc)

            total_bandwidth = total_read_bandwidth + total_write_bandwidth
            logging.info(f"Total Read: {total_read_bandwidth:.2f} MB/s, Total Write: {total_write_bandwidth:.2f} MB/s, Total: {total_bandwidth:.2f} MB/s")

            if total_bandwidth > LIMIT_MB / 8 and not policy_applied:
                logging.warning(f"Current total bandwidth: {total_bandwidth:.2f} MB/s exceeds limit. Applying QoS policy.")
                apply_qos_policy(LIMIT_MB)
                policy_applied = True
            elif total_bandwidth <= LIMIT_MB / 8 and policy_applied:
                logging.info(f"Current total bandwidth: {total_bandwidth:.2f} MB/s is within the limit. Removing QoS policy.")
                remove_qos_policy()
                policy_applied = False

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
