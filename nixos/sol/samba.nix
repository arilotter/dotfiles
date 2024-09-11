{...}: {
  services.samba = {
    enable = true;
    enableNmbd = true;
    enableWinbindd = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = sol
      server role = standalone server
      map to guest = Bad User
      guest account = nobody
    '';
    shares = {
      "public" = {
        path = "/mnt/storage/public";
        "browseable" = "yes";
        "public" = "yes";
        "guest only" = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force create mode" = "0644";
        "force directory mode" = "0755";
      };
      "storage" = {
        path = "/mnt/storage";
        "browseable" = "yes";
        "guest ok" = "no";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force create mode" = "0644";
        "force directory mode" = "0755";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.avahi.extraServiceFiles.smb = ''
    <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
    <service-group>
      <name replace-wildcards="yes">%h</name>
      <service>
        <type>_smb._tcp</type>
        <port>445</port>
      </service>
    </service-group>
  '';
}
