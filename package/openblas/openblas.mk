################################################################################
#
# openblas
#
################################################################################

OPENBLAS_VERSION = f04af36ad0e85b64f12a7c38095383192cc52345
OPENBLAS_SITE = $(call github,xianyi,OpenBLAS,$(OPENBLAS_VERSION))
OPENBLAS_LICENSE = BSD-3c
OPENBLAS_LICENSE_FILES = LICENSE
OPENBLAS_INSTALL_STAGING = YES

# Initialise OpenBLAS make options to $(TARGET_CONFIGURE_OPTS)
OPENBLAS_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS)

# Enable cross-compiling
OPENBLAS_MAKE_OPTS += CROSS=1

# Set OpenBLAS target
OPENBLAS_MAKE_OPTS += TARGET=$(BR2_PACKAGE_OPENBLAS_TARGET)

# Disable fortran by default until we add BR2_TOOLCHAIN_HAS_FORTRAN
# hidden symbol to our toolchain infrastructure
OPENBLAS_MAKE_OPTS += ONLY_CBLAS=1

# Enable/Disable multi-threading (not for static-only since it uses dlfcn.h)
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS):$(BR2_STATIC_LIBS),y:)
OPENBLAS_MAKE_OPTS += USE_THREAD=1
else
OPENBLAS_MAKE_OPTS += USE_THREAD=0
endif

# Static-only/Shared-only toggle
ifeq ($(BR2_STATIC_LIBS),y)
OPENBLAS_MAKE_OPTS += NO_SHARED=1
else ifeq ($(BR2_SHARED_LIBS),y)
OPENBLAS_MAKE_OPTS += NO_STATIC=1
endif

define OPENBLAS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(OPENBLAS_MAKE_OPTS) \
		-C $(@D)
endef

define OPENBLAS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(OPENBLAS_MAKE_OPTS) \
		-C $(@D) install PREFIX=$(STAGING_DIR)/usr
endef

define OPENBLAS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(OPENBLAS_MAKE_OPTS) \
		-C $(@D) install PREFIX=$(TARGET_DIR)/usr
endef

$(eval $(generic-package))
