{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
	    device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            }; 
            lvm_system = {
              size = "60G";
              content = {
                type = "lvm_pv";
                vg = "vg_system";
              };
            };
            lvm_data = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "vg_data";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      vg_system = {
        type = "lvm_vg";
        lvs = {
          lv_system = {
            size = "40G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
            };
          };
          lv_swap = {
            size = "4G";
            content = {
              type = "swap";
              priority = 100;
            };
          };
        };
      };
      vg_data = {
        type = "lvm_vg";
        lvs = {
          lv_data = {
            size = "1G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/data";
            };
          };
        };
      };
    };
  };
}
