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

def check_qos_policy_exists() -> bool:
    try:
        command = f'powershell -Command "Get-NetQosPolicy -Name \'{QOS_POLICY_NAME}\' -ErrorAction SilentlyContinue"'
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        return QOS_POLICY_NAME in result.stdout
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to check QoS policy: {e}")
        return False

def apply_qos_policy(bandwidth_mb: int):
    try:
        if check_qos_policy_exists():
            remove_qos_policy()

        command = f'powershell -Command "$policy = New-NetQosPolicy -Name \'{QOS_POLICY_NAME}\' -AppPathNameMatchCondition \'{PROCESS_NAME}\' -ThrottleRateActionBitsPerSecond {bandwidth_mb * 1000000}; $filter = New-NetQosTrafficClass -NetworkProfile All -PolicyStore ActiveStore -Name \'{QOS_POLICY_NAME}_Filter\' -Priority 1 -NetQosPolicy $policy; $filter | Set-NetQosTrafficClass -NetworkProfile All -PolicyStore ActiveStore -Priority 1 -Algorithm Strict -BandwidthPercentage 100"'
        subprocess.run(command, shell=True, check=True)
        logging.info(f"QoS policy with {bandwidth_mb} MB limit applied.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to apply QoS policy: {e}")

def remove_qos_policy():
    try:
        if check_qos_policy_exists():
            command = f'powershell -Command "Remove-NetQosPolicy -Name \'{QOS_POLICY_NAME}\' -Confirm:$false; Remove-NetQosTrafficClass -Name \'{QOS_POLICY_NAME}_Filter\' -Confirm:$false"'
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
        initial_usage = get_process_bandwidth(proc)
        last_check_time = time.time()
        
        while True:
            current_time = time.time()
            elapsed_time = current_time - last_check_time
            current_usage = get_process_bandwidth(proc)
            bandwidth = (current_usage - initial_usage) / elapsed_time / 1024 / 1024  # MB/s

            if bandwidth > LIMIT_MB / 8 and not policy_applied:  # Convert MB to MB/s
                logging.warning(f"Current bandwidth: {bandwidth:.2f} MB/s exceeds limit. Applying QoS policy.")
                apply_qos_policy(LIMIT_MB)
                policy_applied = True
            elif bandwidth <= LIMIT_MB / 8 and policy_applied:
                logging.info(f"Current bandwidth: {bandwidth:.2f} MB/s is within the limit. Removing QoS policy.")
                remove_qos_policy()
                policy_applied = False
            else:
                logging.info(f"Current bandwidth: {bandwidth:.2f} MB/s. No action needed.")

            initial_usage = current_usage
            last_check_time = current_time
            time.sleep(CHECK_INTERVAL)

    except KeyboardInterrupt:
        logging.info("Monitoring stopped by user.")
    except Exception as e:
        logging.exception(f"An unexpected error occurred: {e}")
    finally:
        if policy_applied:
            remove_qos_policy()

if __name__ == '__main__':
    main()

print("Script execution completed.")
