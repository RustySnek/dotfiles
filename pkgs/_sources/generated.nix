# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  anime4k = {
    pname = "anime4k";
    version = "78e4f78f65b772e94bae6e7db5c49af1e889f784";
    src = fetchFromGitHub ({
      owner = "bloc97";
      repo = "Anime4K";
      rev = "78e4f78f65b772e94bae6e7db5c49af1e889f784";
      fetchSubmodules = false;
      sha256 = "sha256-dKFVNd3DtZ1AbJodoa82FfKhBJu39RMrI5e0To+vqwU=";
    });
  };
  manix = {
    pname = "manix";
    version = "d08e7ca185445b929f097f8bfb1243a8ef3e10e4";
    src = fetchFromGitHub ({
      owner = "mlvzk";
      repo = "manix";
      rev = "d08e7ca185445b929f097f8bfb1243a8ef3e10e4";
      fetchSubmodules = false;
      sha256 = "sha256-GqPuYscLhkR5E2HnSFV4R48hCWvtM3C++3zlJhiK/aw=";
    });
  };
}
