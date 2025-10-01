import os
import re
import subprocess


def get_cpu_usage_macos():
    """Gets CPU usage on macOS using the 'ps' command."""
    try:
        # Get CPU usage for all processes
        output = subprocess.check_output(
            ['ps', '-A', '-o', '%cpu']).decode('utf-8')
        # Sum up all CPU percentages
        cpu_percentages = [float(x)
                           for x in output.split('\n')[1:] if x.strip()]
        total_cpu = sum(cpu_percentages)
        return min(total_cpu, 100)  # Cap at 100%
    except Exception as e:
        print(f"Error getting CPU usage: {e}")
        return None


def get_memory_usage_macos():
    """Gets memory usage on macOS using 'vm_stat' and 'sysctl' commands."""
    try:
        # Get total memory
        total_memory = int(subprocess.check_output(
            ['sysctl', '-n', 'hw.memsize']).decode('utf-8').strip())

        # Get memory statistics
        vm_stat = subprocess.check_output(['vm_stat']).decode('utf-8')

        # Parse memory statistics
        pages_free = int(re.search(r'Pages free:\s+(\d+)', vm_stat).group(1))
        pages_active = int(
            re.search(r'Pages active:\s+(\d+)', vm_stat).group(1))
        pages_inactive = int(
            re.search(r'Pages inactive:\s+(\d+)', vm_stat).group(1))
        pages_speculative = int(
            re.search(r'Pages speculative:\s+(\d+)', vm_stat).group(1))
        pages_wired = int(
            re.search(r'Pages wired down:\s+(\d+)', vm_stat).group(1))

        # Calculate memory usage (4096 bytes per page)
        page_size = 4096
        free_memory = pages_free * page_size
        active_memory = pages_active * page_size
        inactive_memory = pages_inactive * page_size
        speculative_memory = pages_speculative * page_size
        wired_memory = pages_wired * page_size

        used_memory = active_memory + wired_memory
        total_used_memory = used_memory + inactive_memory + speculative_memory
        percent_used = (total_used_memory / total_memory) * 100

        return {
            "total": total_memory,
            "free": free_memory,
            "active": active_memory,
            "inactive": inactive_memory,
            "speculative": speculative_memory,
            "wired": wired_memory,
            "percent": percent_used
        }
    except Exception as e:
        print(f"Error getting memory usage: {e}")
        return None


# Example usage on macOS:
cpu_usage = get_cpu_usage_macos()
if cpu_usage is not None:
    print(f"CPU Usage (macOS): {cpu_usage:.2f}%")

memory_usage = get_memory_usage_macos()
if memory_usage:
    print(f"Memory Usage (macOS):")
    print(f"  Total Memory: {memory_usage['total'] / (1024 ** 3):.2f} GB")
    print(f"  Free Memory: {memory_usage['free'] / (1024 ** 3):.2f} GB")
    print(f"  Active Memory: {memory_usage['active'] / (1024 ** 3):.2f} GB")
    print(
        f"  Inactive Memory: {memory_usage['inactive'] / (1024 ** 3):.2f} GB")
    print(
        f"  Speculative Memory: {memory_usage['speculative'] / (1024 ** 3):.2f} GB")
    print(f"  Wired Memory: {memory_usage['wired'] / (1024 ** 3):.2f} GB")
    print(f"  Memory Used: {memory_usage['percent']:.2f}%")
