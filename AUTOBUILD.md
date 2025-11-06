# Autobuild Workflow

This repository includes an automated workflow that checks for new Helium Browser releases and automatically builds updated Debian packages.

## How It Works

The autobuild workflow performs the following steps:

1. **Version Checking**: Daily at 00:00 UTC, the workflow checks the [helium-linux GitHub releases](https://github.com/imputnet/helium-linux/releases) for new versions
2. **Metadata Update**: If a new version is detected, it automatically updates:
   - `aur.PKGBUILD` - Version and checksums
   - `build.sh` - Version number and checksums
   - `debian/changelog` - New changelog entry
   - `debian/install` - Source directory path
   - `README.md` - Version references
   - `RELEASE_TEMPLATE.md` - Release notes template
   - `generate-checksums.sh` - Package filenames
3. **Package Build**: Downloads the source files and builds the Debian package using `dpkg-buildpackage`
4. **Release Creation**: Creates a new GitHub release with:
   - The `.deb` package
   - Debug symbols package (if generated)
   - Checksums file

## Workflow Files

- **`.github/workflows/autobuild.yml`**: The main GitHub Actions workflow
- **`scripts/check-version.sh`**: Script to check for new versions
- **`scripts/update-version.sh`**: Script to update version metadata in all files

## Manual Triggering

You can manually trigger the autobuild workflow from the GitHub Actions tab:

1. Go to the repository's **Actions** tab
2. Select **Auto-build and Release** workflow
3. Click **Run workflow**
4. Select the branch and click **Run workflow**

## Schedule

The workflow runs automatically:
- **Daily at 00:00 UTC** to check for new versions
- On **push** to workflow-related files (for testing)

## Requirements

The workflow requires the following GitHub Actions permissions:
- `contents: write` - To create releases and push commits

## Version Detection

The workflow detects new versions by:
1. Fetching the latest release from `https://github.com/imputnet/helium-linux/releases/latest`
2. Comparing it with the current `pkgver` in `aur.PKGBUILD`
3. If different, downloading the tarball and desktop file to calculate checksums

## Build Process

When a new version is detected:
1. Downloads source tarball from helium-linux releases
2. Verifies checksums
3. Extracts and prepares files
4. Runs `dpkg-buildpackage -us -uc -b` to build the package
5. Generates checksums for the built packages
6. Commits version updates to the repository
7. Creates a GitHub release with the packages

## Output

Each successful build produces:
- `helium-browser-bin_<version>-1_amd64.deb` - Main package
- `helium-browser-bin-dbgsym_<version>-1_amd64.deb` - Debug symbols (optional)
- `checksums.txt` - SHA256 and MD5 checksums

## Troubleshooting

### Workflow fails to detect version
- Check if `https://github.com/imputnet/helium-linux/releases/latest` is accessible
- Verify the version format in the releases matches the expected pattern

### Build fails
- Check the build logs in the GitHub Actions run
- Verify all dependencies are properly installed in the workflow
- Ensure the source tarball is downloadable from the helium-linux releases

### Checksums don't match
- The workflow will fail if checksums don't match after download
- This is a security feature to ensure integrity
- If this happens, check the helium-linux release for updated files

## Security

The autobuild workflow includes several security measures:
- Verifies SHA256 checksums before extraction
- Uses official helium-linux releases only
- Commits are signed by `github-actions[bot]`
- All downloads use HTTPS

## Maintenance

The workflow is designed to be maintenance-free, but you may need to update it if:
- The helium-linux release format changes
- The Debian package structure changes
- Additional metadata files need to be updated
- Build dependencies change

## Disabling Autobuild

To disable automatic builds:
1. Go to `.github/workflows/autobuild.yml`
2. Comment out or remove the `schedule` trigger
3. Commit the change

Manual triggering will still be available via the Actions tab.
