# PHLEXMOD Installer Guide

## Overview

The PHLEXMOD installer prepares your database and core configuration for first-time setup. It supports two modes: Full (complete schema and seed data) and Lite (minimal schema for constrained environments).

## Installer Modes

- Full: Creates full schema, indexes, constraints, and initial seed data suitable for production pilots.
- Lite: Creates essential tables and minimal constraints for quick evaluation or limited resources.

## How to Run

1. Ensure prerequisites from the Installation Guide are met.
2. Navigate to `http://your-domain.com/installs/` in your browser.
3. Provide database credentials when prompted.
4. The installer will generate `backend/core/core-config.php` and apply the selected mode.

## Post-Installation Security

- Delete or rename the `/installs` directory immediately after installation.
- Restrict write permissions to `backend/storage/` only.

## Troubleshooting

- Check web server logs for errors.
- Verify database connectivity and credentials.

## Related

- Installation Guide: [installation.md](../installation.md)
