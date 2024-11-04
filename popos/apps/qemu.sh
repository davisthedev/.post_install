sudo apt update

# Check for virtualization support
echo "Checking for virtualization support..."
if ! grep -E -c "(vmx|svm)" /proc/cpuinfo > /dev/null; then
    echo "Error: Virtualization is not supported on this CPU."
    exit 1
fi

# Install QEMU, KVM, virt-manager, and additional dependencies
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager virtinst

# Enable and start libvirt service
sudo systemctl enable --now libvirtd
sudo systemctl start libvirtd
sudo systemctl status libvirtd

# Add the current user to the libvirt and kvm groups
sudo usermod -aG libvirt "$USER"
sudo usermod -aG kvm "$USER"

sudo virt-manager
