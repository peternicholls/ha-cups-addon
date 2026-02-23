# Changelog

All notable changes to this project will be documented in this file.

## [1.1.4] - 2026-02-23

### Fixed
- "Open Addon Settings" button now navigates the parent HA window instead of loading inside the ingress iframe, fixing the double sidebar issue

## [1.1.3] - 2026-02-23

### Fixed
- Reduced nginx CPU usage from ~25% to near-zero by disabling access logging (`access_log off`); HA's ingress health-check polling was generating constant stdout I/O
- Reduced `worker_connections` from 256 to 64 and `keepalive_timeout` from 30s to 5s for a single-page server
- Added `worker_rlimit_nofile 128` and `accept_mutex on` for minimal resource usage

## [1.1.2] - 2026-02-23

### Fixed
- nginx ingress server no longer interferes with other HA addon UIs (e.g. Terminal showing 401)
  - nginx now binds to `127.0.0.1:8099` only instead of `0.0.0.0:8099`, preventing it from occupying ports on all host interfaces
  - Debian's default nginx site configs (`sites-enabled/default`, `sites-available/`) removed at build time to ensure no stray port 80 listener is created when running with host networking

## [1.1.1] - 2026-02-23

### Fixed
- CUPS web interface now accessible without authentication from the local network
  - Changed `<Location />` and `<Location /admin>` from `Allow @LOCAL` to `Allow all` to fix 401 Unauthorized errors when accessing CUPS via hostname
  - Admin operations (printer management, configuration) still require authentication
  - Suitable for home network use where trusted local access is expected

## [1.1.0] - 2026-02-23

### Added
- Ingress landing page served by nginx on port 8099, replacing the broken direct CUPS proxy via HA sidebar
  - Displays a link to open the CUPS web interface at `http://[ha-host]:631` (built dynamically in the browser)
  - Button to open the addon settings page in Home Assistant directly
  - Explains why the ingress page exists (CUPS auth/redirect incompatibility with HA ingress proxy)
  - Links to CUPS documentation and the addon GitHub repository
  - Shows the addon version in the footer
- `nginx` added as a runtime dependency for serving the ingress page
- New `ingress-server` s6 service (longrun), started after `cups-config` completes

### Changed
- `ingress_port` changed from `631` to `8099` — CUPS remains accessible directly on port 631 from the local network; the HA sidebar now shows the landing page instead of proxying CUPS directly
- Ingress landing page HTML is generated at startup by `cups-config.sh` via `tempio`, so the version and addon slug are always current

## [1.0.13] - 2026-02-22

### Fixed
- cups-browsed run script: replaced unsupported `--no-daemon` flag with `-d` (debug/foreground mode) for cups-filters 1.28.17 compatibility

## [1.0.12] - 2026-02-22

### Changed
- Temporarily removed `image` field from config.yaml — addon now builds locally from Dockerfile until ghcr.io package visibility issues are resolved

## [1.0.11] - 2026-02-22

### Added
- User-configurable addon options:
  - `admin_user` — CUPS admin username (default: `print`)
  - `admin_password` — CUPS admin password (default: `print`)
  - `cups_log_level` — CUPS log verbosity: `warn`, `info`, or `debug` (default: `warn`)
  - `default_paper_size` — default paper size: `A4` or `Letter` (default: `A4`)

### Changed
- Admin user is now created at runtime by `cups-config.sh` using the configured `admin_user`/`admin_password` options, replacing the hardcoded build-time `print:print` user
- Removed the `whois` package from the Dockerfile (no longer needed now that `mkpasswd` is replaced by `chpasswd`)

## [1.0.10] - 2026-02-22

### Added
- CHANGELOG.md to track releases

## [1.0.9] - 2026-02-22

### Added
- `cups-browsed` and `cups-filters` packages for automatic AirPrint advertisement via Avahi
- s6 service for `cups-browsed`, started after `cups-server`

## [1.0.8] - 2026-02-22

### Changed
- CUPS access and error logs now written to stdout/stderr so they appear in the HA addon log viewer

## [1.0.7] - 2026-02-22

### Added
- GitHub Actions workflow to build and push multi-arch Docker images to ghcr.io on tag push
- `image` field in `config.yaml` so Home Assistant can detect and offer updates without reinstall
- Auto-create GitHub Release with generated release notes on each tag
- CI build status and release version badges in README

## [1.0.6] - 2026-02-22

### Fixed
- Blank white screen when opening the web UI via HA ingress
  - `ServerAlias *` added to accept any Host header from the ingress proxy
  - `DefaultEncryption Never` to prevent CUPS issuing HTTPS redirects that break ingress

## [1.0.5] - 2026-02-22

### Fixed
- Removed `ulimit -n 1048576` from all startup scripts (`run.sh`, `avahi-daemon/run`, `cups-server/run`, `dbus-daemon/run`) — the call always failed with "Operation not permitted" in the restricted HA OS container environment and produced log noise on every start

## [1.0.4] - Prior

### Changed
- Forked from [niallr/ha-cups-addon](https://github.com/niallr/ha-cups-addon) for x86/amd64 compatibility
- Refactored s6 service scripts and cups-config oneshot for reliability
- Fixed null URL handling in internal/external URL detection
- Fixed infinite startup loop and ingress configuration issues
