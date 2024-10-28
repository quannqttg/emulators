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
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

def find_process_by_name(name: str) -> Optional[psutil.Process]:
    for proc in psutil.process_iter(['name']):
        if proc.info['name'] == name:
            return proc
    return None

def get_process_bandwidth(proc: psutil.Process) -> tuple[int, int]:
    try:
        io_counters = proc.io_counters()
        logging.info(f"Process PID {proc.pid}: Read bytes - {io_counters.read_bytes}, Write bytes - {io_counters.write_bytes}")
        return io_counters.read_bytes, io_counters.write_bytes
    except (psutil.NoSuchProcess, psutil.AccessDenied) as e:
        logging.error(f"Error getting bandwidth for PID {proc.pid}: {e}")
        return 0, 0

def apply_qos_policy(bandwidth_mb: int):
    try:
        remove_qos_policy()
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
    processes = [proc for proc in psutil.process_iter(['name']) if proc.info['name'] == PROCESS_NAME]
    logging.info(f"Detected {len(processes)} instance(s) of {PROCESS_NAME}.")

    if not processes:
        logging.error(f"{PROCESS_NAME} is not running.")
        return

    logging.info(f"Monitoring {len(processes)} instance(s) of {PROCESS_NAME}.")
    policy_applied = False
    initial_readings = [get_process_bandwidth(proc) for proc in processes]
    last_check_time = time.time()

    while True:
        time.sleep(CHECK_INTERVAL)
        processes = [proc for proc in processes if psutil.pid_exists(proc.pid)]
        
        if not processes:
            logging.error(f"No instances of {PROCESS_NAME} are running. Exiting.")
            break

        current_time = time.time()
        elapsed_time = current_time - last_check_time

        current_readings = [get_process_bandwidth(proc) for proc in processes]
        total_bandwidth = 0
        
        for (initial_read, initial_write), (current_read, current_write) in zip(initial_readings, current_readings):
            read_bandwidth = (current_read - initial_read) / elapsed_time / 1024 / 1024
            write_bandwidth = (current_write - initial_write) / elapsed_time / 1024 / 1024
            total_bandwidth += (read_bandwidth + write_bandwidth)
            logging.info(f"Instance PID: {proc.pid} - Read: {read_bandwidth:.2f} MB/s, Write: {write_bandwidth:.2f} MB/s")

        average_bandwidth = total_bandwidth / len(processes)
        logging.info(f"Average Total Bandwidth: {average_bandwidth:.2f} MB/s")

        if average_bandwidth > LIMIT_MB / 8 and not policy_applied:
            logging.warning(f"Average bandwidth: {average_bandwidth:.2f} MB/s exceeds limit. Applying QoS policy.")
            apply_qos_policy(LIMIT_MB)
            policy_applied = True
        elif average_bandwidth <= LIMIT_MB / 8 and policy_applied:
            logging.info(f"Average bandwidth: {average_bandwidth:.2f} MB/s is within the limit. Removing QoS policy.")
            remove_qos_policy()
            policy_applied = False

        initial_readings = current_readings
        last_check_time = current_time

if __name__ == "__main__":
    main()
