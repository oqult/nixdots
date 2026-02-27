{ lib,config,pkgs, ...}:

let
  lgEdid = pkgs.runCommand "lg-edid" {} ''
    mkdir -p $out/lib/firmware/edid
    cp ${./edid/lg-34gn850b-dp.bin} \
      $out/lib/firmware/edid/lg-34gn850b-dp.bin
  '';
in

{
  hardware.firmware = [ lgEdid ];
  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.overdrive.enable = true;
  boot.kernelParams = [
    "drm.edid_firmware=DP-1:edid/lg-34gn850b-dp.bin"
    "video=DP-1:e"
    "amdgpu.dc=1"
    "amdgpu.pfeaturemask=0xffffffff"
  ];
}
