target "_args-2023_2" {
  args = {
    INSTALLER_BIN = "FPGAs_AdaptiveSoCs_Unified_2023.2_1013_2256_Lin64.bin"
    INSTALLER_CONFIG = "config/2023.2/install_config.txt"
  }
}

target "_args-2024_1" {
  args = {
    INSTALLER_BIN = "FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023_Lin64.bin"
    INSTALLER_CONFIG = "config/2024.1/install_config.txt"
  }
}

target "_args-2024_2" {
  args = {
    INSTALLER_BIN = "FPGAs_AdaptiveSoCs_Unified_2024.2_1113_1001_Lin64.bin"
    INSTALLER_CONFIG = "config/2024.2/install_config.txt"
  }
}

target "_args-2025_1" {
  args = {
    INSTALLER_BIN = "FPGAs_AdaptiveSoCs_Unified_SDI_2025.1_0530_0145_Lin64.bin"
    INSTALLER_CONFIG = "config/2025.1/install_config.txt"
  }
}

target "_config" {
  dockerfile = "Dockerfile"
  target = "configgen"
}

target "_build" {
  dockerfile = "Dockerfile"
  secret = ["type=file,id=secret,src=secret.txt"]
}

group "config-all" {
  targets = [
    "config-2023_2",
    "config-2024_1",
    "config-2024_2",
  ]
}

target "config-2023_2" {
  inherits = ["_config", "_args-2023_2"]
  output = ["type=local,dest=${replace(target._args-2023_2.args.INSTALLER_CONFIG, "/install_config.txt", "")}"]
}

target "config-2024_1" {
  inherits = ["_config", "_args-2024_1"]
  output = ["type=local,dest=${replace(target._args-2024_1.args.INSTALLER_CONFIG, "/install_config.txt", "")}"]
}

target "config-2024_2" {
  inherits = ["_config", "_args-2024_2"]
  output = ["type=local,dest=${replace(target._args-2024_2.args.INSTALLER_CONFIG, "/install_config.txt", "")}"]
}

target "config-2025_1" {
  inherits = ["_config", "_args-2025_1"]
  output = ["type=local,dest=${replace(target._args-2025_1.args.INSTALLER_CONFIG, "/install_config.txt", "")}"]
}

group "build-all" {
  targets = [
    "build-2023_2",
    "build-2024_1",
    "build-2024_2",
    "build-2025_1",
  ]
}

target "build-2023_2" {
  inherits = ["_build", "_args-2023_2"]
  tags = ["vivado:v2023.2"]
}

target "build-2024_1" {
  inherits = ["_build", "_args-2024_1"]
  tags = ["vivado:v2024.1"]
}

target "build-2024_2" {
  inherits = ["_build", "_args-2024_2"]
  tags = ["vivado:v2024.2"]
}

target "build-2025_1" {
  inherits = ["_build", "_args-2025_1"]
  tags = ["vivado:v2025.1"]
}
