# cpu_optimizer.py

import psutil
import logging
import multiprocessing
import os
from typing import Dict

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Constants
PROCESS_NAMES = ['MuMuVMMHeadless.exe', 'MuMuPlayer.exe', 'crashpad_handler']
TOTAL_CORES = psutil.cpu_count(logical=False)
MAX_CPU_USAGE = 0.8  # 80% CPU capacity

def worker_process(process_id: int) -> None:
    """Function to handle each process."""
    logging.info(f"Process {process_id} started. PID: {os.getpid()}")
    while True:
        pass  # Simulate work here

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

if __name__ == "__main__":
    optimize_cpu_usage()
