import psutil
import time
import subprocess
import logging
import multiprocessing
import os
from typing import List, Tuple, Dict

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Constants
PROCESS_NAMES = ['MuMuVMMHeadless.exe', 'MuMuPlayer.exe']
CHECK_INTERVAL = 5  # seconds
QOS_POLICY_NAME = "BandwidthLimitPolicy"
TOTAL_CORES = psutil.cpu_count(logical=False)
MAX_CPU_USAGE = 0.8  # 80% CPU capacity

def get_process_bandwidth(proc: psutil.Process) -> Tuple[int, int]:
    """Get the read and write bandwidth of a process."""
    try:
        io_counters = proc.io_counters()
        return io_counters.read_bytes, io_counters.write_bytes
    except (psutil.NoSuchProcess, psutil.AccessDenied) as e:
        logging.error(f"Error getting bandwidth: {e}")
        return 0, 0

def apply_qos_policy(bandwidth_mb: int) -> None:
    """Apply a Quality of Service (QoS) policy to limit bandwidth."""
    try:
        remove_qos_policy()
        command = f'powershell -Command "New-NetQosPolicy -Name \'{QOS_POLICY_NAME}\' -AppPathNameMatchCondition \'{PROCESS_NAMES[0]}\' -ThrottleRateActionBitsPerSecond {bandwidth_mb * 1000000}"'
        subprocess.run(command, shell=True, check=True)
        logging.info(f"QoS policy with {bandwidth_mb} MB limit applied.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to apply QoS policy: {e}")

def remove_qos_policy() -> None:
    """Remove the existing QoS policy."""
    try:
        command = f'powershell -Command "Remove-NetQosPolicy -Name \'{QOS_POLICY_NAME}\' -Confirm:$false"'
        subprocess.run(command, shell=True, check=True)
        logging.info("QoS policy removed.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to remove QoS policy: {e}")

def worker_process(process_id: int) -> None:
    """Function to handle each process."""
    logging.info(f"Process {process_id} started. PID: {os.getpid()}")
    while True:
        time.sleep(0.1)  # Simulate work here

def get_running_process_count() -> Dict[str, int]:
    """Get the count of running processes for specified names."""
    count = {name: 0 for name in PROCESS_NAMES}
    for proc in psutil.process_iter(['name']):
        if proc.info['name'] in count:
            count[proc.info['name']] += 1
    return count

def set_cpu_affinity(proc: psutil.Process, index: int) -> None:
    """Set CPU affinity for a process."""
    allowed_cores = [index % TOTAL_CORES]
    try:
        proc.cpu_affinity(allowed_cores)
        logging.info(f"Process {proc.pid} is allowed to use core: {allowed_cores}")
    except Exception as e:
        logging.error(f"Failed to set CPU affinity for PID {proc.pid}: {e}")

def limit_cpu_usage(proc: psutil.Process) -> None:
    """Limit CPU usage for a process."""
    try:
        proc.nice(psutil.BELOW_NORMAL_PRIORITY_CLASS)
        logging.info(f"CPU limit applied to PID {proc.pid}.")
    except Exception as e:
        logging.error(f"Failed to apply CPU limit to PID {proc.pid}: {e}")

def optimize_cpu_usage() -> None:
    """Optimize CPU usage for processes."""
    running_counts = get_running_process_count()
    total_running = sum(running_counts.values())
    
    logging.info(f"Currently running processes: {running_counts}")

    cores_to_use = int(MAX_CPU_USAGE * TOTAL_CORES)
    logging.info(f"Total available cores: {TOTAL_CORES}, Cores allocated for processes: {cores_to_use}")

    processes_to_start = cores_to_use - total_running
    
    if processes_to_start <= 0:
        logging.info("No new processes need to be started.")
        return

    processes = []
    for i in range(processes_to_start):
        p = multiprocessing.Process(target=worker_process, args=(i,))
        p.start()
        processes.append(p)

        proc = psutil.Process(p.pid)
        set_cpu_affinity(proc, i)
        limit_cpu_usage(proc)

    for p in processes:
        p.join()

def monitor_bandwidth(limit_mb: int) -> None:
    """Monitor and control bandwidth usage."""
    policy_applied = False
    while True:
        processes = [proc for proc in psutil.process_iter(['name']) if proc.info['name'] in PROCESS_NAMES]
        if not processes:
            logging.error(f"None of the processes {PROCESS_NAMES} are running.")
            time.sleep(CHECK_INTERVAL)
            continue

        logging.info(f"Monitoring {len(processes)} instance(s) of {', '.join(PROCESS_NAMES)}.")

        try:
            initial_readings = [get_process_bandwidth(proc) for proc in processes]
            last_check_time = time.time()

            while True:
                time.sleep(CHECK_INTERVAL)

                processes = [proc for proc in processes if psutil.pid_exists(proc.pid)]
                if not processes:
                    logging.error(f"No instances of {', '.join(PROCESS_NAMES)} are running. Exiting.")
                    return

                current_time = time.time()
                elapsed_time = current_time - last_check_time

                current_readings = [get_process_bandwidth(proc) for proc in processes]
                total_bandwidth = sum((current_read - initial_read + current_write - initial_write) 
                                      for (initial_read, initial_write), (current_read, current_write) 
                                      in zip(initial_readings, current_readings)) / elapsed_time / 1024 / 1024  # MB/s

                average_bandwidth = total_bandwidth / len(processes)
                logging.info(f"Average Total Bandwidth: {average_bandwidth:.2f} MB/s")

                if average_bandwidth > limit_mb / 8 and not policy_applied:
                    logging.warning(f"Average bandwidth: {average_bandwidth:.2f} MB/s exceeds limit. Applying QoS policy.")
                    apply_qos_policy(limit_mb)
                    policy_applied = True
                elif average_bandwidth <= limit_mb / 8 and policy_applied:
                    logging.info(f"Average bandwidth: {average_bandwidth:.2f} MB/s is within the limit. Removing QoS policy.")
                    remove_qos_policy()
                    policy_applied = False

                initial_readings = current_readings
                last_check_time = current_time

        except KeyboardInterrupt:
            logging.info("Monitoring stopped by user.")
            break
        except Exception as e:
            logging.exception(f"An unexpected error occurred: {e}")
        finally:
            if policy_applied:
                remove_qos_policy()
                logging.info("QoS policy removed during cleanup.")

def main() -> None:
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
