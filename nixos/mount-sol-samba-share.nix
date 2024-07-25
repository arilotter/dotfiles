{
  # try to mount the samba share on boot!
  fileSystems."/mnt/storage" = {
    device = "//sol.local/storage";
    fsType = "cifs";
    options = [ "users" "rw" "nofail" "dir_mode=0777" "file_mode=0777"];
  };
}