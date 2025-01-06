# Copyright (C) 2022 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Kernel
TARGET_KERNEL_DIR ?= device/samsung/o1s-kernel

# Inherit from the common tree
include device/samsung/universal2100-common/BoardConfigCommon.mk

# Inherit from the proprietary configuration
include vendor/samsung/o1s/BoardConfigVendor.mk

DEVICE_PATH := device/samsung/o1s

# APEX image
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Camera ID's
SOONG_CONFIG_samsungCameraVars_extra_ids := 52,56,58

# Display
TARGET_SCREEN_DENSITY := 420
