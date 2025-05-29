import sys
import os

print("--- Environment Check ---")
print("Python Executable:", sys.executable)
print("Python Version:", sys.version)

print("\nsys.path:")
for i, p in enumerate(sys.path):
    print(f"  [{i}] {p}")

# Specifically check if the venv site-packages is in sys.path
expected_site_packages = os.path.abspath(os.path.join(os.path.dirname(sys.executable), '..', 'lib', f'python{sys.version_info.major}.{sys.version_info.minor}', 'site-packages'))
print(f"\nExpected venv site-packages: {expected_site_packages}")
if expected_site_packages in sys.path:
    print("OK: Expected venv site-packages IS in sys.path.")
else:
    print("WARNING: Expected venv site-packages IS NOT in sys.path.")


print("\nAttempting to import yaml...")
try:
    import yaml
    print("SUCCESS: Successfully imported yaml.")
    print("yaml module location:", yaml.__file__)
except ModuleNotFoundError as e:
    print(f"FAILED: Failed to import yaml. Error: {e}")
except Exception as e:
    print(f"FAILED: An unexpected error occurred while importing yaml: {e}")


print("\n--- Checking common environment variables that might interfere ---")
print(f"PYTHONPATH: {os.environ.get('PYTHONPATH')}")
print(f"PYTHONHOME: {os.environ.get('PYTHONHOME')}")

print("\n--- Contents of expected venv site-packages ---")
if os.path.exists(expected_site_packages):
    print(f"Listing contents of: {expected_site_packages}")
    found_yaml_related = False
    for item in sorted(os.listdir(expected_site_packages)):
        print(f"  - {item}")
        if 'yaml' in item.lower() or 'pyyaml' in item.lower():
            found_yaml_related = True
    if found_yaml_related:
        print("OK: Found yaml-related files/folders in site-packages.")
    else:
        print("WARNING: Did NOT find yaml-related files/folders in site-packages listing (check manually).")
else:
    print(f"ERROR: Expected venv site-packages directory does not exist: {expected_site_packages}")

print("\n--- End of Environment Check ---")
