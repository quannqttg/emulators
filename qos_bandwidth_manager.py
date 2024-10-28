import psutil
import time
import subprocess
import logging
from typing import Optional

# Constants
PROCESS_NAMES = ['MuMuVMMHeadless.exe', 'MuMuPlayer.exe']  # List of process names to monitor
LIMIT_MB = 300
LIMIT_BYTES = LIMIT_MB * 1024 * 1024
CHECK_INTERVAL = 5  # seconds
QOS_POLICY_NAME = "BandwidthLimitPolicy"

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_process_bandwidth(proc: psutil.Process) -> tuple[int, int]:
    """Get the read and write bandwidth of a process."""
    try:
        io_counters = proc.io_counters()
        return io_counters.read_bytes, io_counters.write_bytes
    except (psutil.NoSuchProcess, psutil.AccessDenied) as e:
        logging.error(f"Error getting bandwidth: {e}")
        return 0, 0

def apply_qos_policy(bandwidth_mb: int):
    """Apply a Quality of Service (QoS) policy to limit bandwidth."""
    try:
        # Remove existing policy if it exists
        remove_qos_policy()
        
        # Create new QoS policy
        command = f'powershell -Command "New-NetQosPolicy -Name \'{QOS_POLICY_NAME}\' -AppPathNameMatchCondition \'{PROCESS_NAMES[0]}\' -ThrottleRateActionBitsPerSecond {bandwidth_mb * 1000000}"'
        subprocess.run(command, shell=True, check=True)
        logging.info(f"QoS policy with {bandwidth_mb} MB limit applied.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to apply QoS policy: {e}")

def remove_qos_policy():
    """Remove the existing QoS policy."""
    try:
        command = f'powershell -Command "Remove-NetQosPolicy -Name \'{QOS_POLICY_NAME}\' -Confirm:$false"'
        subprocess.run(command, shell=True, check=True)
        logging.info("QoS policy removed.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to remove QoS policy: {e}")

def main():
    while True:
        # Find all processes with the names in PROCESS_NAMES
        processes = [proc for proc in psutil.process_iter(['name']) if proc.info['name'] in PROCESS_NAMES]
        if not processes:
            logging.error(f"None of the processes {PROCESS_NAMES} are running.")
            time.sleep(CHECK_INTERVAL)
            continue  # Go back to the start of the loop to check again

        logging.info(f"Monitoring {len(processes)} instance(s) of {', '.join(PROCESS_NAMES)}.")

        try:
            policy_applied = False
            initial_readings = [get_process_bandwidth(proc) for proc in processes]
            last_check_time = time.time()

            while True:
                time.sleep(CHECK_INTERVAL)

                # Check if any processes are still running
                processes = [proc for proc in processes if psutil.pid_exists(proc.pid)]
                if not processes:
                    logging.error(f"No instances of {', '.join(PROCESS_NAMES)} are running. Exiting.")
                    break

                current_time = time.time()
                elapsed_time = current_time - last_check_time

                current_readings = [get_process_bandwidth(proc) for proc in processes]
                total_bandwidth = 0
                
                for proc, (initial_read, initial_write), (current_read, current_write) in zip(processes, initial_readings, current_readings):
                    read_bandwidth = (current_read - initial_read) / elapsed_time / 1024 / 1024  # MB/s
                    write_bandwidth = (current_write - initial_write) / elapsed_time / 1024 / 1024  # MB/s
                    total_bandwidth += (read_bandwidth + write_bandwidth)

                    logging.info(f"Instance PID: {proc.pid} - Read: {read_bandwidth:.2f} MB/s, Write: {write_bandwidth:.2f} MB/s")

                # Calculate average bandwidth
                average_bandwidth = total_bandwidth / len(processes)
                logging.info(f"Average Total Bandwidth: {average_bandwidth:.2f} MB/s")

                # QoS policy logic
                if average_bandwidth > LIMIT_MB / 8 and not policy_applied:
                    logging.warning(f"Average bandwidth: {average_bandwidth:.2f} MB/s exceeds limit. Applying QoS policy.")
                    apply_qos_policy(LIMIT_MB)
                    policy_applied = True
                elif average_bandwidth <= LIMIT_MB / 8 and policy_applied:
                    logging.info(f"Average bandwidth: {average_bandwidth:.2f} MB/s is within the limit. Removing QoS policy.")
                    remove_qos_policy()
                    policy_applied = False

                # Update initial readings for the next loop
                initial_readings = current_readings
                last_check_time = current_time

        except KeyboardInterrupt:
            logging.info("Monitoring stopped by user.")
            break  # Exit the main loop
        except Exception as e:
            logging.exception(f"An unexpected error occurred: {e}")
        finally:
            if policy_applied:
                remove_qos_policy()
                logging.info("QoS policy removed during cleanup.")

if __name__ == "__main__":
    main()
