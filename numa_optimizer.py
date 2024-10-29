import psutil
import win32api
import win32process
import logging
import time
from typing import List, Dict
import ctypes

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Constants
PROCESS_NAMES = ['MuMuVMMHeadless.exe', 'MuMuPlayer.exe']
REFRESH_INTERVAL = 60  # seconds

def get_numa_node_count() -> int:
    """Get the number of NUMA nodes in the system."""
    try:
        return ctypes.windll.kernel32.GetNumaHighestNodeNumber() + 1
    except Exception as e:
        logging.error(f"Failed to get NUMA node count: {e}")
        return 1

def find_processes() -> List[psutil.Process]:
    """Find all processes matching the specified names."""
    processes = []
    for proc in psutil.process_iter(['name', 'pid']):
        try:
            if proc.info['name'] in PROCESS_NAMES:
                processes.append(proc)
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    return processes

def set_numa_affinity(pid: int, node: int) -> None:
    """Set NUMA affinity for a process."""
    try:
        process_handle = win32api.OpenProcess(win32process.PROCESS_ALL_ACCESS, False, pid)
        mask = 1 << node
        win32process.SetProcessAffinityMask(process_handle, mask)
        win32api.CloseHandle(process_handle)
        logging.info(f"NUMA affinity for PID {pid} set to node {node}.")
    except Exception as e:
        logging.error(f"Failed to set NUMA affinity for PID {pid}: {e}")

def distribute_processes(processes: List[psutil.Process], numa_nodes: int) -> Dict[int, List[psutil.Process]]:
    """Distribute processes equally among NUMA nodes."""
    distribution = {i: [] for i in range(numa_nodes)}
    for i, proc in enumerate(processes):
        node = i % numa_nodes
        distribution[node].append(proc)
    return distribution

def main():
    numa_nodes = get_numa_node_count()
    logging.info(f"Detected {numa_nodes} NUMA node(s)")

    while True:
        try:
            processes = find_processes()
            logging.info(f"Found {len(processes)} matching processes")

            distribution = distribute_processes(processes, numa_nodes)

            for node, node_processes in distribution.items():
                for proc in node_processes:
                    set_numa_affinity(proc.pid, node)

            logging.info(f"Process distribution: {', '.join(f'Node {node}: {len(procs)}' for node, procs in distribution.items())}")
            logging.info(f"Waiting {REFRESH_INTERVAL} seconds before next refresh")
            time.sleep(REFRESH_INTERVAL)
        except KeyboardInterrupt:
            logging.info("Script terminated by user.")
            break
        except Exception as e:
            logging.error(f"An unexpected error occurred: {e}")
            time.sleep(REFRESH_INTERVAL)

if __name__ == "__main__":
    main()
